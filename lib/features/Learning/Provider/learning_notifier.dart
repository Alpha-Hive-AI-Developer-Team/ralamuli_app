import 'package:flutter_riverpod/legacy.dart';
import 'package:ralamuli_translator/core/database/dictionary_repository.dart';
import 'package:ralamuli_translator/features/Learning/Model/learning_model.dart';
import 'package:ralamuli_translator/features/Learning/Provider/learning_state.dart';

final learningProvider = StateNotifierProvider<LearningNotifier, LearningState>(
  (ref) => LearningNotifier(ref.watch(dictionaryRepositoryProvider)),
);

class LearningNotifier extends StateNotifier<LearningState> {
  LearningNotifier(this._repository)
    : super(const LearningState(words: [], isLoading: true)) {
    Future.microtask(_loadRandomWords);
  }

  final DictionaryRepository _repository;

  Future<void> _loadRandomWords() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final entries = await _repository.fetchRandomEntries(limit: 15);
      final words = entries
          .map(
            (entry) => WordItem(
              id: entry.id.toString(),
              ralamuli: entry.raramuri,
              english: entry.english,
              espanol: entry.spanish,
              imageUrl: '',
            ),
          )
          .toList();

      state = state.copyWith(
        words: words,
        isLoading: false,
        clearError: true,
      );
    } catch (_) {
      state = state.copyWith(
        words: const [],
        isLoading: false,
        errorMessage: 'Unable to load learning words.',
      );
    }
  }

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
