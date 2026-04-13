import 'package:ralamuli_translator/features/Learning/Model/learning_model.dart';

class LearningState {
  final List<WordItem> words;

  const LearningState({required this.words});

  int get learnedCount => words.where((w) => w.isLearned).length;
  int get totalCount => words.length;

  double get progressPercent => totalCount == 0 ? 0 : learnedCount / totalCount;

  LearningState copyWith({List<WordItem>? words}) {
    return LearningState(words: words ?? this.words);
  }
}
