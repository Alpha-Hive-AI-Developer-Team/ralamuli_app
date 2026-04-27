import 'package:ralamuli_translator/features/Learning/Model/learning_model.dart';

class LearningState {
  final List<WordItem> words;
  final bool isLoading;
  final String? errorMessage;

  const LearningState({
    required this.words,
    this.isLoading = false,
    this.errorMessage,
  });

  int get learnedCount => words.where((w) => w.isLearned).length;
  int get totalCount => words.length;

  double get progressPercent => totalCount == 0 ? 0 : learnedCount / totalCount;

  LearningState copyWith({
    List<WordItem>? words,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LearningState(
      words: words ?? this.words,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
