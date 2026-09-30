import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:ralamuli_translator/core/Utils/search_normalizer.dart';
import 'package:sqflite/sqflite.dart';

class DictionaryDatabase {
  DictionaryDatabase._();

  static final DictionaryDatabase instance = DictionaryDatabase._();

  static const _databaseName = 'raramuri_dictionary.db';

  /// Bump this whenever assets/data/raramuri_dictionary.json changes, otherwise
  /// installed apps keep searching their previously seeded copy.
  static const _databaseVersion = 3;
  static const _assetPath = 'assets/data/raramuri_dictionary.json';

  /// Search term ranks: a match on an entry's full text beats a match on one
  /// of its alternatives.
  static const primaryRank = 0;
  static const alternativeRank = 1;

  Database? _database;

  Future<Database> get database async {
    final existingDatabase = _database;
    if (existingDatabase != null) {
      return existingDatabase;
    }

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    final database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await _createTables(db);
        await _createIndexes(db);
        await _seedDatabase(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion != newVersion) {
          await _dropTables(db);
          await _createTables(db);
          await _createIndexes(db);
          await _seedDatabase(db);
        }
      },
    );

    await _seedIfEmpty(database);
    _database = database;
    return database;
  }

  Future<void> initialize() async {
    await database;
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE dictionary (
        id INTEGER PRIMARY KEY,
        english TEXT,
        spanish TEXT,
        raramuri TEXT,
        pos TEXT,
        tag TEXT,
        note TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE search_terms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER NOT NULL,
        language TEXT NOT NULL,
        term TEXT NOT NULL,
        rank INTEGER NOT NULL,
        FOREIGN KEY(word_id) REFERENCES dictionary(id)
      );
    ''');
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_search_terms ON search_terms(language, term);',
    );
  }

  Future<void> _dropTables(Database db) async {
    await db.execute('DROP TABLE IF EXISTS search_terms;');
    // Tables from database version 2 and earlier.
    await db.execute('DROP TABLE IF EXISTS alt_meanings;');
    await db.execute('DROP TABLE IF EXISTS variants;');
    await db.execute('DROP TABLE IF EXISTS forms;');
    await db.execute('DROP TABLE IF EXISTS dictionary;');
  }

  Future<void> _seedIfEmpty(Database db) async {
    final countResult = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM dictionary',
    );
    final count = Sqflite.firstIntValue(countResult) ?? 0;

    if (count == 0) {
      await _seedDatabase(db);
    }
  }

  Future<void> _seedDatabase(Database db) async {
    final rawJson = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
    final entries = (decoded['entries'] as List<dynamic>? ?? const []);
    final phrases = (decoded['phrases'] as List<dynamic>? ?? const []);

    await db.transaction((txn) async {
      final batch = txn.batch();

      void addSearchTerms(
        int wordId,
        String language,
        Object? primary,
        List<String> alternatives,
      ) {
        final isEnglish = language == 'english';
        final ranks = <String, int>{};

        if (primary is String) {
          for (final key in searchKeysFor(primary, isEnglish: isEnglish)) {
            ranks[key] = primaryRank;
          }
        }
        for (final alternative in alternatives) {
          for (final key in searchKeysFor(alternative, isEnglish: isEnglish)) {
            ranks.putIfAbsent(key, () => alternativeRank);
          }
        }

        ranks.forEach((term, rank) {
          batch.insert('search_terms', {
            'word_id': wordId,
            'language': language,
            'term': term,
            'rank': rank,
          });
        });
      }

      var maxEntryId = 0;
      for (final item in entries) {
        final entry = item as Map<String, dynamic>;
        final wordId = entry['id'] as int;
        if (wordId > maxEntryId) maxEntryId = wordId;

        batch.insert('dictionary', {
          'id': wordId,
          'english': entry['word'],
          'spanish': entry['spanish'],
          'raramuri': entry['raramuri'],
          'pos': entry['pos'],
          'tag': entry['tag'],
          'note': entry['note'],
        });

        addSearchTerms(wordId, 'english', entry['word'], [
          ..._stringList(entry['alt_meanings']),
        ]);
        addSearchTerms(wordId, 'spanish', entry['spanish'], [
          ..._stringList(entry['spanish_alt']),
        ]);
        addSearchTerms(wordId, 'raramuri', entry['raramuri'], [
          ..._stringList(entry['variants']),
          ..._stringList(entry['forms']),
        ]);
      }

      // Seed phrases after entries, offset past the largest entry id.
      for (final item in phrases) {
        final phrase = item as Map<String, dynamic>;
        final phraseId = (phrase['id'] as int) + maxEntryId;

        batch.insert('dictionary', {
          'id': phraseId,
          'english': phrase['meaning'],
          'spanish': phrase['spanish'],
          'raramuri': phrase['raramuri'],
          'pos': 'phrase',
          'tag': null,
          'note': null,
        });

        addSearchTerms(phraseId, 'english', phrase['meaning'], const []);
        addSearchTerms(phraseId, 'spanish', phrase['spanish'], const []);
        addSearchTerms(phraseId, 'raramuri', phrase['raramuri'], const []);
      }

      await batch.commit(noResult: true);
    });
  }

  List<String> _stringList(Object? rawValue) {
    if (rawValue is! List) {
      return const [];
    }

    return rawValue
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
