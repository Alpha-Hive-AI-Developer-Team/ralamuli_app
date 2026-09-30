// Normalizes the raw spreadsheet export into the dictionary asset used by the app.
//
// Usage (from the project root):
//   dart run tool/normalize_dictionary.dart
//
// Input:  tool/data/raramuri_dictionary.raw.json  (raw export, never edited by hand)
// Output: assets/data/raramuri_dictionary.json    (normalized, bundled with the app)
//
// After regenerating the asset, bump `_databaseVersion` in
// lib/core/database/dictionary_database.dart so installed apps reseed.

import 'dart:convert';
import 'dart:io';

const _inputPath = 'tool/data/raramuri_dictionary.raw.json';
const _outputPath = 'assets/data/raramuri_dictionary.json';

/// Hand fixes for entries the generic rules cannot repair.
/// Keyed by entry id, then field name.
const Map<int, Map<String, String>> _manualFixes = {
  321: {'spanish': '¿cuándo comenzó a toser?'},
  577: {
    'raramuri':
        '¿kabé mujé níwara gomá ko? ¿kabé mujé níwara gómaka? ¡atí nibí!',
    'spanish': '¿dónde está tu pelota? ¡aquí está!',
  },
  1024: {'spanish': '¡ay!'},
  2672: {'spanish': 'caballo'},
  2940: {'raramuri': 'kapírawa', 'note': 'pretérito: capíranari'},
  3521: {'raramuri': 'kuri atí towí shukórea'},
  6532: {'raramuri': 'sikimea', 'note': 'futuro de: sika'},
  6667: {'raramuri': 'siyete'},
  7784: {'raramuri': 'wiba', 'note': 'variante de: uba'},
  7965: {
    'raramuri': 'yena',
    'spanish': 'andar',
    'note': 'variante de: eyena, iyena',
  },
};

/// Entries whose source text is corrupted beyond repair.
const Set<int> _excludedIds = {
  6608, // Rarámuri field contains garbled non-Latin characters ("s दोबाराta").
};

void main() {
  final raw =
      jsonDecode(File(_inputPath).readAsStringSync()) as Map<String, dynamic>;
  final rawEntries = (raw['entries'] as List).cast<Map<String, dynamic>>();

  final seen = <String>{};
  final entries = <Map<String, Object>>[];
  var duplicates = 0;

  for (final rawEntry in rawEntries) {
    final id = rawEntry['id'] as int;
    if (_excludedIds.contains(id)) continue;
    final fixes = _manualFixes[id] ?? const {};

    final english = cleanText(
      fixes['word'] ?? rawEntry['word'] as String,
      balance: false,
    );
    final raramuri = cleanText(
      fixes['raramuri'] ?? rawEntry['raramuri'] as String,
    );
    final spanish = cleanText(
      fixes['spanish'] ?? rawEntry['spanish'] as String,
    );

    if (english.isEmpty || raramuri.isEmpty || spanish.isEmpty) continue;

    final key = '$english\u0000$raramuri\u0000$spanish'.toLowerCase();
    if (!seen.add(key)) {
      duplicates++;
      continue;
    }

    final entry = <String, Object>{
      'id': id,
      'word': english,
      'raramuri': raramuri,
      'spanish': spanish,
    };

    final altMeanings = splitAlternatives(english, balance: false);
    final variants = splitAlternatives(raramuri);
    final spanishAlt = splitAlternatives(spanish);
    if (altMeanings.isNotEmpty) entry['alt_meanings'] = altMeanings;
    if (variants.isNotEmpty) entry['variants'] = variants;
    if (spanishAlt.isNotEmpty) entry['spanish_alt'] = spanishAlt;
    if (fixes['note'] != null) entry['note'] = fixes['note']!;
    entry['item_no'] = rawEntry['item_no'] ?? id;

    entries.add(entry);
  }

  final buffer = StringBuffer()
    ..writeln('{')
    ..writeln('  "version": "3.0",')
    ..writeln('  "language": ${jsonEncode(raw['language'] ?? 'Rarámuri')},')
    ..writeln(
      '  "language_alt": ${jsonEncode(raw['language_alt'] ?? 'Tarahumara')},',
    )
    ..writeln('  "total_entries": ${entries.length},')
    ..writeln('  "sources": ${jsonEncode(raw['sources'] ?? const [])},')
    ..writeln('  "entries": [');
  for (var i = 0; i < entries.length; i++) {
    buffer.write('    ${jsonEncode(entries[i])}');
    buffer.writeln(i == entries.length - 1 ? '' : ',');
  }
  buffer
    ..writeln('  ]')
    ..writeln('}');

  File(_outputPath).writeAsStringSync(buffer.toString());
  stdout.writeln(
    'Wrote ${entries.length} entries to $_outputPath '
    '(${rawEntries.length - entries.length} removed, $duplicates exact duplicates).',
  );
}

const _graveToAcute = {
  'à': 'á',
  'è': 'é',
  'ì': 'í',
  'ò': 'ó',
  'ù': 'ú',
  'ä': 'á',
  'À': 'Á',
  'È': 'É',
  'Ì': 'Í',
  'Ò': 'Ó',
  'Ù': 'Ú',
};

/// Cleans a single display string without changing its meaning.
String cleanText(String input, {bool balance = true}) {
  var s = input
      // One glottal stop / apostrophe character.
      .replaceAll(RegExp('[´`’‘ʼ]'), "'")
      // Stray footnote markers and non-Latin corruption.
      .replaceAll('*', '')
      .replaceAll(RegExp(r'[ऀ-ॿ]'), '')
      .replaceAll(RegExp('[—–]'), ' - ');
  _graveToAcute.forEach((from, to) => s = s.replaceAll(from, to));

  s = s
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      // No space before closing punctuation, none after opening punctuation.
      .replaceAllMapped(RegExp(r'\s+([,.;:!?)\]])'), (m) => m[1]!)
      .replaceAllMapped(RegExp(r'([(\[¡¿])\s+'), (m) => m[1]!)
      // Space after a comma that runs into the next word.
      .replaceAllMapped(RegExp(r',(?=[^\s\d])'), (m) => ', ')
      // "?." / "!." -> "?" / "!", and no doubled marks.
      .replaceAllMapped(RegExp(r'([!?])\.(?!\.)'), (m) => m[1]!)
      .replaceAll(RegExp('!{2,}'), '!')
      .replaceAll(RegExp(r'\?{2,}'), '?')
      .replaceAll(RegExp(r'¿\s*¿'), '¿')
      .replaceAll(RegExp('¡{2,}'), '¡')
      // Drop a lone trailing period (keep ellipses).
      .replaceAll(RegExp(r'(?<!\.)\.$'), '')
      .trim();

  if (!balance) return s;
  return s.split(' / ').map(_balanceMarks).join(' / ');
}

/// Fixes simple unbalanced Spanish-style ¡…! / ¿…? pairs within one segment.
String _balanceMarks(String segment) {
  var s = segment.trim();
  if (s.isEmpty) return s;

  int count(String c) => c.allMatches(s).length;

  // "¡pregunta?" -> "¿pregunta?" and "¿exclamación!" -> "¡exclamación!"
  if (s.startsWith('¡') &&
      s.endsWith('?') &&
      count('!') == 0 &&
      count('¿') == 0) {
    s = '¿${s.substring(1)}';
  } else if (s.startsWith('¿') &&
      s.endsWith('!') &&
      count('?') == 0 &&
      count('¡') == 0) {
    s = '¡${s.substring(1)}';
  }

  for (final (open, close) in [('¡', '!'), ('¿', '?')]) {
    final opens = count(open);
    final closes = count(close);
    if (opens == 1 && closes == 0 && s.startsWith(open)) {
      s = s.replaceFirst(RegExp(r'[.,;:]$'), '') + close;
    } else if (opens == 0 && closes == 1 && s.endsWith(close)) {
      s = open + s;
    }
  }
  return s;
}

/// Splits a field that packs several alternatives ("A / B", "x, y, z",
/// "¿A? ¿B?") into separately searchable strings. Returns an empty list when
/// the field is a single expression.
List<String> splitAlternatives(String text, {bool balance = true}) {
  final parts = <String>[];

  for (final segment in text.split(' / ')) {
    // Consecutive questions/exclamations: "¿a? ¿b?" -> ["¿a?", "¿b?"]
    final sentences = segment.split(RegExp(r'(?<=[?!])\s+(?=[¿¡])'));
    for (final sentence in sentences) {
      final pieces = sentence
          .split(RegExp(r'[,;]\s*|\.\s+'))
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();
      // Only treat commas as separators for short word lists, not clauses.
      final isWordList =
          pieces.length > 1 &&
          pieces.every((p) => p.split(' ').length <= 3 && !p.contains('?'));
      parts.addAll(isWordList ? pieces : [sentence.trim()]);
    }
  }

  final cleaned = <String>[];
  for (var part in parts) {
    part = part.replaceAllMapped(RegExp(r'^\((.*)\)$'), (m) => m[1]!).trim();
    if (balance) part = _balanceMarks(part);
    if (part.isNotEmpty && !cleaned.contains(part)) cleaned.add(part);
  }

  if (cleaned.length <= 1) return const [];
  return cleaned;
}
