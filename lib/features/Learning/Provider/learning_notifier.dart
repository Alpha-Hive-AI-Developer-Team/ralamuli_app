import 'package:flutter_riverpod/legacy.dart';
import 'package:ralamuli_translator/features/Learning/Model/learning_model.dart';
import 'package:ralamuli_translator/features/Learning/Provider/learning_state.dart';

final learningProvider = StateNotifierProvider<LearningNotifier, LearningState>(
  (ref) => LearningNotifier(),
);

class LearningNotifier extends StateNotifier<LearningState> {
  LearningNotifier() : super(LearningState(words: _initialWords));

  static final List<WordItem> _initialWords = [
    WordItem(
      id: '1',
      ralamuli: "ba'",
      english: 'water',
      espanol: 'agua',
      imageUrl:
          'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=600&q=80',
      isLearned: false,
    ),
    WordItem(
      id: '2',
      ralamuli: "ko'",
      english: 'food',
      espanol: 'comida',
      imageUrl:
          'https://images.unsplash.com/photo-1477322524744-0eece9e79640?w=600&q=80',
      isLearned: true,
    ),
    WordItem(
      id: '3',
      ralamuli: 'kari',
      english: 'house',
      espanol: 'casa',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&q=80',
      isLearned: true,
    ),
    WordItem(
      id: '4',
      ralamuli: 'kuíra',
      english: 'hello',
      espanol: 'hola',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600&q=80',
      isLearned: false,
    ),
    WordItem(
      id: '5',
      ralamuli: 'wikã',
      english: 'goodbye',
      espanol: 'adios',
      imageUrl:
          'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=600&q=80',
      isLearned: false,
    ),
    WordItem(
      id: '6',
      ralamuli: 'rewe',
      english: 'school',
      espanol: 'escuela',
      imageUrl:
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=600&q=80',
      isLearned: false,
    ),
    WordItem(
      id: '7',
      ralamuli: 'nore',
      english: 'teacher',
      espanol: 'maestro',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&q=80',
      isLearned: false,
    ),
  ];

  void toggleLearned(String id) {
    state = state.copyWith(
      words: state.words.map((w) {
        if (w.id == id) return w.copyWith(isLearned: !w.isLearned);
        return w;
      }).toList(),
    );
  }
}
