class DictionaryEntry {
  final int id;
  final String english;
  final String spanish;
  final String raramuri;
  final String? pos;
  final String? tag;
  final String? note;

  const DictionaryEntry({
    required this.id,
    required this.english,
    required this.spanish,
    required this.raramuri,
    this.pos,
    this.tag,
    this.note,
  });

  factory DictionaryEntry.fromMap(Map<String, Object?> map) {
    return DictionaryEntry(
      id: map['id'] as int,
      english: (map['english'] as String?) ?? '',
      spanish: (map['spanish'] as String?) ?? '',
      raramuri: (map['raramuri'] as String?) ?? '',
      pos: map['pos'] as String?,
      tag: map['tag'] as String?,
      note: map['note'] as String?,
    );
  }

  String textForLanguage(String language) {
    switch (language) {
      case 'English':
        return english;
      case 'Español':
        return spanish;
      case 'Ralamuli':
        return raramuri;
      default:
        return english;
    }
  }
}
