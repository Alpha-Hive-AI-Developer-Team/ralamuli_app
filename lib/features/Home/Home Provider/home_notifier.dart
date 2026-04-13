import 'package:flutter_riverpod/legacy.dart';
import 'package:ralamuli_translator/features/Home/Model/home_model.dart';

final translatorProvider =
    StateNotifierProvider<TranslatorNotifier, TranslatorState>(
      (ref) => TranslatorNotifier(),
    );

class TranslatorNotifier extends StateNotifier<TranslatorState> {
  TranslatorNotifier() : super(const TranslatorState());

  static const List<String> availableLanguages = [
    'English',
    'Español',
    'Ralamuli',
  ];

  void updateInputText(String text) {
    state = state.copyWith(
      inputText: text,
      // Reset translation when input changes
      translatedText: '',
      status: TranslationStatus.idle,
    );
  }

  void clearInput() {
    state = state.copyWith(
      inputText: '',
      translatedText: '',
      status: TranslationStatus.idle,
    );
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
      inputText: state.translatedText,
      translatedText: state.inputText,
      status: state.translatedText.isNotEmpty
          ? TranslationStatus.success
          : TranslationStatus.idle,
    );
  }

  void openDropdown({required bool isSource}) {
    state = state.copyWith(isDropdownOpen: true, isSelectingSource: isSource);
  }

  void closeDropdown() {
    state = state.copyWith(isDropdownOpen: false);
  }

  void selectLanguage(String language) {
    if (state.isSelectingSource) {
      // Prevent same language on both sides
      if (language == state.targetLanguage) {
        state = state.copyWith(
          sourceLanguage: language,
          targetLanguage: state.sourceLanguage,
          isDropdownOpen: false,
        );
      } else {
        state = state.copyWith(sourceLanguage: language, isDropdownOpen: false);
      }
    } else {
      if (language == state.sourceLanguage) {
        state = state.copyWith(
          targetLanguage: language,
          sourceLanguage: state.targetLanguage,
          isDropdownOpen: false,
        );
      } else {
        state = state.copyWith(targetLanguage: language, isDropdownOpen: false);
      }
    }
  }

  Future<void> translate() async {
    if (state.inputText.trim().isEmpty) return;

    state = state.copyWith(status: TranslationStatus.loading);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mock translation logic
    final mockTranslations = {
      'water': "ba'",
      'hello': 'kéachi',
      'sun': 'rayénali',
    };

    final key = state.inputText.trim().toLowerCase();
    final result = mockTranslations[key];

    if (result != null) {
      state = state.copyWith(
        translatedText: result,
        status: TranslationStatus.success,
      );
    } else {
      state = state.copyWith(
        translatedText: '',
        status: TranslationStatus.error,
      );
    }
  }
}
