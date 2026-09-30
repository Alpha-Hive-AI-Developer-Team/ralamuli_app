/// Builds comparable search keys from dictionary text and user input.
///
/// Both sides go through [normalizeForSearch], so "Pay attention",
/// "pay attention!" and "¡PAY ATTENTION!" all produce the same key, and
/// accents are optional ("raramuri" matches "rarámuri").
library;

const _accentMap = {
  'á': 'a',
  'à': 'a',
  'ä': 'a',
  'â': 'a',
  'é': 'e',
  'è': 'e',
  'ë': 'e',
  'ê': 'e',
  'í': 'i',
  'ì': 'i',
  'ï': 'i',
  'î': 'i',
  'ó': 'o',
  'ò': 'o',
  'ö': 'o',
  'ô': 'o',
  'ú': 'u',
  'ù': 'u',
  'ü': 'u',
  'û': 'u',
  'ñ': 'n',
};

final _apostrophes = RegExp('[´`’‘ʼ]');
final _nonSearchable = RegExp(r"[^a-z0-9' ]");
final _whitespace = RegExp(r'\s+');
final _parenthetical = RegExp(r'\([^)]*\)|\[[^\]]*\]');

/// Lowercases, folds accents, unifies apostrophes (the Rarámuri glottal stop)
/// and replaces all other punctuation with spaces.
String normalizeForSearch(String text) {
  final buffer = StringBuffer();
  for (final char
      in text.toLowerCase().replaceAll(_apostrophes, "'").split('')) {
    buffer.write(_accentMap[char] ?? char);
  }
  return buffer
      .toString()
      .replaceAll(_nonSearchable, ' ')
      .replaceAll(_whitespace, ' ')
      .trim();
}

/// All search keys a single dictionary string should be findable by:
/// the full text, the text without parenthetical notes, and for English
/// infinitives the bare verb ("to break" -> "break").
Set<String> searchKeysFor(String text, {bool isEnglish = false}) {
  final keys = <String>{
    normalizeForSearch(text),
    normalizeForSearch(text.replaceAll(_parenthetical, ' ')),
  };

  if (isEnglish) {
    for (final key in keys.toList()) {
      if (key.startsWith('to ') && key.length > 3) keys.add(key.substring(3));
    }
  }

  keys.removeWhere((key) => key.isEmpty);
  return keys;
}
