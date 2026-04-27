import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ralamuli_translator/core/data/translation_entries.dart';
import 'package:ralamuli_translator/core/database/dictionary_database.dart';
import 'package:ralamuli_translator/core/database/models/dictionary_entry.dart';
import 'package:sqflite/sqflite.dart';

final dictionaryRepositoryProvider = Provider<DictionaryRepository>(
  (ref) => DictionaryRepository(DictionaryDatabase.instance),
);

final dictionaryInitializationProvider = FutureProvider<void>((ref) async {
  await ref.watch(dictionaryRepositoryProvider).initialize();
});

class DictionaryRepository {
  DictionaryRepository(this._database);

  final DictionaryDatabase _database;

  Future<void> initialize() async {
    await _database.initialize();
  }

  Future<DictionaryEntry?> searchEntry({
    required String sourceLanguage,
    required String input,
  }) async {
    final trimmedInput = input.trim();
    if (trimmedInput.isEmpty) {
      return null;
    }

    final db = await _database.database;
    final sourceColumn = _dictionaryColumnFor(sourceLanguage);
    final directMatch = await _searchDictionaryColumn(
      db: db,
      column: sourceColumn,
      input: trimmedInput,
    );

    if (directMatch != null) {
      return directMatch;
    }

    for (final table in _relatedTablesFor(sourceLanguage)) {
      final relatedMatch = await _searchRelatedTable(
        db: db,
        tableName: table.tableName,
        valueColumn: table.valueColumn,
        input: trimmedInput,
      );

      if (relatedMatch != null) {
        return relatedMatch;
      }
    }

    // Search for phrase prefixes
    final prefixMatch = await _searchPhrasePrefix(
      db: db,
      sourceColumn: sourceColumn,
      input: trimmedInput,
    );

    if (prefixMatch != null) {
      return prefixMatch;
    }

    return null;
  }

  Future<List<DictionaryEntry>> fetchRandomEntries({int limit = 15}) async {
    final db = await _database.database;
    final results = await db.rawQuery('''
      SELECT *
      FROM dictionary
      WHERE english IS NOT NULL
        AND english != ''
        AND spanish IS NOT NULL
        AND spanish != ''
        AND raramuri IS NOT NULL
        AND raramuri != ''
      ORDER BY RANDOM()
      LIMIT $limit
      ''');

    return results.map(DictionaryEntry.fromMap).toList();
  }

  Future<DictionaryEntry?> _searchDictionaryColumn({
    required Database db,
    required String column,
    required String input,
  }) async {
    final results = await db.rawQuery(
      '''
      SELECT *
      FROM dictionary
      WHERE LOWER($column) LIKE LOWER(?)
      ORDER BY
        CASE
          WHEN LOWER($column) = LOWER(?) THEN 0
          WHEN LOWER($column) LIKE LOWER(?) THEN 1
          ELSE 2
        END,
        LENGTH($column) ASC
      LIMIT 1
      ''',
      ['%$input%', input, '$input%'],
    );

    if (results.isEmpty) {
      return null;
    }

    return DictionaryEntry.fromMap(results.first);
  }

  Future<DictionaryEntry?> _searchRelatedTable({
    required Database db,
    required String tableName,
    required String valueColumn,
    required String input,
  }) async {
    final results = await db.rawQuery(
      '''
      SELECT d.*
      FROM dictionary d
      INNER JOIN $tableName t ON t.word_id = d.id
      WHERE LOWER(t.$valueColumn) LIKE LOWER(?)
      ORDER BY
        CASE
          WHEN LOWER(t.$valueColumn) = LOWER(?) THEN 0
          WHEN LOWER(t.$valueColumn) LIKE LOWER(?) THEN 1
          ELSE 2
        END,
        LENGTH(t.$valueColumn) ASC
      LIMIT 1
      ''',
      ['%$input%', input, '$input%'],
    );

    if (results.isEmpty) {
      return null;
    }

    return DictionaryEntry.fromMap(results.first);
  }

  Future<DictionaryEntry?> _searchPhrasePrefix({
    required Database db,
    required String sourceColumn,
    required String input,
  }) async {
    final results = await db.rawQuery(
      'SELECT * FROM dictionary WHERE pos = ?',
      ['phrase'],
    );

    for (final row in results) {
      final text = row[sourceColumn] as String?;
      if (text != null && text.endsWith('...')) {
        final prefix = text.substring(0, text.length - 3);
        if (input.toLowerCase().startsWith(prefix.toLowerCase())) {
          return DictionaryEntry.fromMap(row);
        }
      }
    }

    return null;
  }

  String _dictionaryColumnFor(String language) {
    switch (language) {
      case AppLanguages.english:
        return 'english';
      case AppLanguages.espanol:
        return 'spanish';
      case AppLanguages.ralamuli:
        return 'raramuri';
      default:
        return 'english';
    }
  }

  List<_RelatedTable> _relatedTablesFor(String language) {
    switch (language) {
      case AppLanguages.english:
        return const [_RelatedTable('alt_meanings', 'meaning')];
      case AppLanguages.ralamuli:
        return const [
          _RelatedTable('forms', 'form'),
          _RelatedTable('variants', 'variant'),
        ];
      default:
        return const [];
    }
  }
}

class _RelatedTable {
  final String tableName;
  final String valueColumn;

  const _RelatedTable(this.tableName, this.valueColumn);
}
