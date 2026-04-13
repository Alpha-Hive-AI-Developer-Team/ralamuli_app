class WordItem {
  final String id;
  final String ralamuli;
  final String english;
  final String espanol;
  final String imageUrl;
  final bool isLearned;

  const WordItem({
    required this.id,
    required this.ralamuli,
    required this.english,
    required this.espanol,
    required this.imageUrl,
    this.isLearned = false,
  });

  WordItem copyWith({bool? isLearned}) {
    return WordItem(
      id: id,
      ralamuli: ralamuli,
      english: english,
      espanol: espanol,
      imageUrl: imageUrl,
      isLearned: isLearned ?? this.isLearned,
    );
  }
}
