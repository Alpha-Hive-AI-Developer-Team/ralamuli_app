import 'package:flutter_riverpod/legacy.dart';
import 'package:ralamuli_translator/core/data/translation_entries.dart';
import 'package:ralamuli_translator/features/Home/Model/home_model.dart';

final translatorProvider =
    StateNotifierProvider<TranslatorNotifier, TranslatorState>(
      (ref) => TranslatorNotifier(),
    );

class TranslatorNotifier extends StateNotifier<TranslatorState> {
  TranslatorNotifier() : super(const TranslatorState());

  static const List<String> availableLanguages = AppLanguages.all;

  void updateInputText(String text) {
    state = state.copyWith(
      inputText: text,
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
    state = _buildSyncedState(
      previousState: state,
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
      fallbackInputText: state.translatedText.isNotEmpty
          ? state.translatedText
          : state.inputText,
      fallbackTranslatedText: state.inputText,
    );
  }

  void openDropdown({required bool isSource}) {
    state = state.copyWith(isDropdownOpen: true, isSelectingSource: isSource);
  }

  void closeDropdown() {
    state = state.copyWith(isDropdownOpen: false);
  }

  void selectLanguage(String language) {
    var nextSourceLanguage = state.sourceLanguage;
    var nextTargetLanguage = state.targetLanguage;

    if (state.isSelectingSource) {
      if (language == state.targetLanguage) {
        nextTargetLanguage = state.sourceLanguage;
      }
      nextSourceLanguage = language;
    } else {
      if (language == state.sourceLanguage) {
        nextSourceLanguage = state.targetLanguage;
      }
      nextTargetLanguage = language;
    }

    state = _buildSyncedState(
      previousState: state,
      sourceLanguage: nextSourceLanguage,
      targetLanguage: nextTargetLanguage,
      closeDropdown: true,
    );
  }

  Future<void> translate() async {
    final input = state.inputText.trim();
    if (input.isEmpty) return;

    state = state.copyWith(status: TranslationStatus.loading);

    await Future.delayed(const Duration(milliseconds: 450));

    final entry = findTranslationEntry(
      language: state.sourceLanguage,
      text: input,
    );

    if (entry != null) {
      state = state.copyWith(
        inputText: entry.textForLanguage(state.sourceLanguage),
        translatedText: entry.textForLanguage(state.targetLanguage),
        status: TranslationStatus.success,
      );
      return;
    }

    state = state.copyWith(
      translatedText: '',
      status: TranslationStatus.error,
    );
  }

  TranslatorState _buildSyncedState({
    required TranslatorState previousState,
    required String sourceLanguage,
    required String targetLanguage,
    bool closeDropdown = false,
    String? fallbackInputText,
    String? fallbackTranslatedText,
  }) {
    final matchedEntry = _resolveCurrentEntry(previousState);

    if (matchedEntry != null) {
      return previousState.copyWith(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        inputText: matchedEntry.textForLanguage(sourceLanguage),
        translatedText: matchedEntry.textForLanguage(targetLanguage),
        status: TranslationStatus.success,
        isDropdownOpen: closeDropdown ? false : previousState.isDropdownOpen,
      );
    }

    final nextInputText =
        fallbackInputText ??
        (sourceLanguage == previousState.sourceLanguage
            ? previousState.inputText
            : '');

    return previousState.copyWith(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      inputText: nextInputText,
      translatedText: fallbackTranslatedText ?? '',
      status: TranslationStatus.idle,
      isDropdownOpen: closeDropdown ? false : previousState.isDropdownOpen,
    );
  }

  TranslationEntry? _resolveCurrentEntry(TranslatorState currentState) {
    final fromInput = findTranslationEntry(
      language: currentState.sourceLanguage,
      text: currentState.inputText,
    );
    if (fromInput != null) {
      return fromInput;
    }

    if (currentState.translatedText.trim().isEmpty) {
      return null;
    }

    return findTranslationEntry(
      language: currentState.targetLanguage,
      text: currentState.translatedText,
    );
  }
}
