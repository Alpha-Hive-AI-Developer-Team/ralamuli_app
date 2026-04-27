import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DictionaryDatabase {
  DictionaryDatabase._();

  static final DictionaryDatabase instance = DictionaryDatabase._();

  static const _databaseName = 'raramuri_dictionary.db';
  static const _databaseVersion = 2;
  static const _assetPath = 'assets/data/raramuri_dictionary.json';

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
      CREATE TABLE forms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER,
        form TEXT,
        FOREIGN KEY(word_id) REFERENCES dictionary(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE variants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER,
        variant TEXT,
        FOREIGN KEY(word_id) REFERENCES dictionary(id)
      );
    ''');

    await db.execute('''
      CREATE TABLE alt_meanings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word_id INTEGER,
        meaning TEXT,
        FOREIGN KEY(word_id) REFERENCES dictionary(id)
      );
    ''');
  }

  Future<void> _createIndexes(Database db) async {
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_english ON dictionary(english);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_spanish ON dictionary(spanish);',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_raramuri ON dictionary(raramuri);',
    );
  }

  Future<void> _dropTables(Database db) async {
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

      for (final item in entries) {
        final entry = item as Map<String, dynamic>;
        final wordId = entry['id'] as int;

        batch.insert('dictionary', {
          'id': wordId,
          'english': entry['word'],
          'spanish': entry['spanish'],
          'raramuri': entry['raramuri'],
          'pos': entry['pos'],
          'tag': entry['tag'],
          'note': entry['note'],
        });

        for (final form in _stringList(entry['forms'])) {
          batch.insert('forms', {
            'word_id': wordId,
            'form': form,
          });
        }

        for (final variant in _stringList(entry['variants'])) {
          batch.insert('variants', {
            'word_id': wordId,
            'variant': variant,
          });
        }

        for (final meaning in _stringList(entry['alt_meanings'])) {
          batch.insert('alt_meanings', {
            'word_id': wordId,
            'meaning': meaning,
          });
        }
      }

      // Seed phrases
      for (final item in phrases) {
        final phrase = item as Map<String, dynamic>;
        final phraseId = phrase['id'] as int;

        batch.insert('dictionary', {
          'id': phraseId + 1000, // Offset to avoid ID conflicts
          'english': phrase['meaning'],
          'spanish': phrase['spanish'],
          'raramuri': phrase['raramuri'],
          'pos': 'phrase',
          'tag': null,
          'note': null,
        });
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
