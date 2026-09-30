import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ralamuli_translator/core/Utils/search_normalizer.dart';
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

  static const _minSubstringQueryLength = 3;

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

    final termMatch = await _searchTerms(
      db: db,
      language: sourceColumn,
      query: normalizeForSearch(trimmedInput),
    );

    if (termMatch != null) {
      return termMatch;
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

  /// Finds the best entry whose normalized search terms contain [query].
  ///
  /// Ranking: exact term match, then the query as the leading words of a
  /// term, then as whole words inside a term, then as a partial-word prefix,
  /// then anywhere. Ties prefer an entry's full text over its alternatives,
  /// then the shortest term.
  Future<DictionaryEntry?> _searchTerms({
    required Database db,
    required String language,
    required String query,
  }) async {
    if (query.isEmpty) {
      return null;
    }

    // Normalized queries only contain [a-z0-9' ], so no LIKE escaping needed.
    // Very short queries must match whole words to avoid random substrings.
    final allowSubstring = query.length >= _minSubstringQueryLength;
    final results = await db.rawQuery(
      '''
      SELECT d.*
      FROM search_terms t
      INNER JOIN dictionary d ON d.id = t.word_id
      WHERE t.language = ?
        AND (
          t.term = ?
          OR t.term LIKE ?
          OR (' ' || t.term || ' ') LIKE ?
          ${allowSubstring ? 'OR t.term LIKE ?' : ''}
        )
      ORDER BY
        CASE
          WHEN t.term = ? THEN 0
          WHEN t.term LIKE ? THEN 1
          WHEN (' ' || t.term || ' ') LIKE ? THEN 2
          WHEN t.term LIKE ? THEN 3
          ELSE 4
        END,
        t.rank ASC,
        LENGTH(t.term) ASC,
        d.id ASC
      LIMIT 1
      ''',
      [
        language,
        query,
        '$query %',
        '% $query %',
        if (allowSubstring) '%$query%',
        query,
        '$query %',
        '% $query %',
        '$query%',
      ],
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
}
