class TranslationEntry {
  final String id;
  final String english;
  final String espanol;
  final String ralamuli;
  final String imageUrl;
  final bool isLearned;

  const TranslationEntry({
    required this.id,
    required this.english,
    required this.espanol,
    required this.ralamuli,
    required this.imageUrl,
    this.isLearned = false,
  });

  String textForLanguage(String language) {
    switch (language) {
      case AppLanguages.english:
        return english;
      case AppLanguages.espanol:
        return espanol;
      case AppLanguages.ralamuli:
        return ralamuli;
      default:
        return english;
    }
  }
}

class AppLanguages {
  static const String english = 'English';
  static const String espanol = 'Español';
  static const String ralamuli = 'Ralamuli';

  static const List<String> all = [english, espanol, ralamuli];
}

const List<TranslationEntry> translationEntries = [
  TranslationEntry(
    id: '1',
    english: 'water',
    espanol: 'agua',
    ralamuli: "ba'",
    imageUrl:
        'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=600&q=80',
  ),
  TranslationEntry(
    id: '2',
    english: 'food',
    espanol: 'comida',
    ralamuli: "ko'",
    imageUrl:
        'https://images.unsplash.com/photo-1477322524744-0eece9e79640?w=600&q=80',
    isLearned: true,
  ),
  TranslationEntry(
    id: '3',
    english: 'house',
    espanol: 'casa',
    ralamuli: 'kari',
    imageUrl:
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&q=80',
    isLearned: true,
  ),
  TranslationEntry(
    id: '4',
    english: 'hello',
    espanol: 'hola',
    ralamuli: 'kuira',
    imageUrl:
        'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&q=80',
  ),
  TranslationEntry(
    id: '5',
    english: 'goodbye',
    espanol: 'adios',
    ralamuli: 'wika',
    imageUrl:
        'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=600&q=80',
  ),
  TranslationEntry(
    id: '6',
    english: 'school',
    espanol: 'escuela',
    ralamuli: 'rewe',
    imageUrl:
        'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&q=80',
  ),
  TranslationEntry(
    id: '7',
    english: 'teacher',
    espanol: 'maestro',
    ralamuli: 'nore',
    imageUrl:
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=600&q=80',
  ),
  TranslationEntry(
    id: '8',
    english: 'sun',
    espanol: 'sol',
    ralamuli: 'rayenali',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=600&q=80',
  ),
  TranslationEntry(
    id: '9',
    english: 'moon',
    espanol: 'luna',
    ralamuli: 'metzaka',
    imageUrl:
        'https://images.unsplash.com/photo-1508261303786-aba5f7f3c9f5?w=600&q=80',
  ),
  TranslationEntry(
    id: '10',
    english: 'mother',
    espanol: 'madre',
    ralamuli: 'iye',
    imageUrl:
        'https://images.unsplash.com/photo-1516589091380-5d8e87df6999?w=600&q=80',
  ),
  TranslationEntry(
    id: '11',
    english: 'father',
    espanol: 'padre',
    ralamuli: 'onora',
    imageUrl:
        'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=600&q=80',
  ),
  TranslationEntry(
    id: '12',
    english: 'friend',
    espanol: 'amigo',
    ralamuli: 'napawika',
    imageUrl:
        'https://images.unsplash.com/photo-1517486808906-6ca8b3f04846?w=600&q=80',
  ),
];

TranslationEntry? findTranslationEntry({
  required String language,
  required String text,
}) {
  final normalizedText = normalizeTranslationText(text);

  for (final entry in translationEntries) {
    if (normalizeTranslationText(entry.textForLanguage(language)) ==
        normalizedText) {
      return entry;
    }
  }

  return null;
}

String normalizeTranslationText(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ü', 'u')
      .replaceAll('ñ', 'n')
      .replaceAll("'", '')
      .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}
