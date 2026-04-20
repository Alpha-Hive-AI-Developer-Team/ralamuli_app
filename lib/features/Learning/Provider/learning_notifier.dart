import 'package:flutter_riverpod/legacy.dart';
import 'package:ralamuli_translator/core/data/translation_entries.dart';
import 'package:ralamuli_translator/features/Learning/Model/learning_model.dart';
import 'package:ralamuli_translator/features/Learning/Provider/learning_state.dart';

final learningProvider = StateNotifierProvider<LearningNotifier, LearningState>(
  (ref) => LearningNotifier(),
);

class LearningNotifier extends StateNotifier<LearningState> {
  LearningNotifier() : super(LearningState(words: _initialWords));

  static final List<WordItem> _initialWords = translationEntries
      .map(
        (entry) => WordItem(
          id: entry.id,
          ralamuli: entry.ralamuli,
          english: entry.english,
          espanol: entry.espanol,
          imageUrl: entry.imageUrl,
          isLearned: entry.isLearned,
        ),
      )
      .toList();

  void toggleLearned(String id) {
    state = state.copyWith(
      words: state.words.map((w) {
        if (w.id == id) {
          return w.copyWith(isLearned: !w.isLearned);
        }
        return w;
      }).toList(),
    );
  }
}
