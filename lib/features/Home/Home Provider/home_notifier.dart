import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:ralamuli_translator/core/data/translation_entries.dart';
import 'package:ralamuli_translator/core/database/dictionary_repository.dart';
import 'package:ralamuli_translator/core/database/models/dictionary_entry.dart';
import 'package:ralamuli_translator/features/Home/Model/home_model.dart';
import 'package:ralamuli_translator/features/Setting/setting_notifier.dart';

final translatorProvider =
    StateNotifierProvider<TranslatorNotifier, TranslatorState>(
      (ref) => TranslatorNotifier(ref),
    );

class TranslatorNotifier extends StateNotifier<TranslatorState> {
  TranslatorNotifier(this.ref)
    : super(
        TranslatorState(
          sourceLanguage: ref.watch(settingsProvider).defaultLanguage,
        ),
      ) {
    _repository = ref.watch(dictionaryRepositoryProvider);
    // Listen to settings changes
    ref.listen(settingsProvider, (previous, next) {
      if (previous?.defaultLanguage != next.defaultLanguage) {
        state = state.copyWith(sourceLanguage: next.defaultLanguage);
      }
    });
  }

  late final DictionaryRepository _repository;
  final Ref ref;

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
    state = _buildSwappedState(state);
  }

  void openDropdown({required bool isSource}) {
    state = state.copyWith(isDropdownOpen: true, isSelectingSource: isSource);
  }

  void closeDropdown() {
    state = state.copyWith(isDropdownOpen: false);
  }

  Future<void> selectLanguage(String language) async {
    if (state.isSelectingSource && language == state.targetLanguage) {
      state = _buildSwappedState(state, closeDropdown: true);
      return;
    }

    if (!state.isSelectingSource && language == state.sourceLanguage) {
      state = _buildSwappedState(state, closeDropdown: true);
      return;
    }

    if (state.isSelectingSource) {
      state = state.copyWith(
        sourceLanguage: language,
        inputText: '',
        translatedText: '',
        status: TranslationStatus.idle,
        isDropdownOpen: false,
      );
      return;
    }

    state = state.copyWith(
      targetLanguage: language,
      translatedText: '',
      status: TranslationStatus.idle,
      isDropdownOpen: false,
    );

    if (state.inputText.trim().isNotEmpty) {
      await translate();
    }
  }

  Future<void> translate() async {
    final input = state.inputText.trim();
    if (input.isEmpty) return;

    state = state.copyWith(status: TranslationStatus.loading);

    final entry = await _repository.searchEntry(
      sourceLanguage: state.sourceLanguage,
      input: input,
    );

    if (entry != null) {
      state = state.copyWith(
        translatedText: _buildTranslatedText(
          entry,
          state.targetLanguage,
          input,
        ),
        status: TranslationStatus.success,
      );
      return;
    }

    state = state.copyWith(translatedText: '', status: TranslationStatus.error);
  }

  String _buildTranslatedText(
    DictionaryEntry entry,
    String targetLanguage,
    String input,
  ) {
    final baseTranslation = entry.textForLanguage(targetLanguage);
    if (entry.pos == 'phrase' &&
        entry.textForLanguage(state.sourceLanguage).endsWith('...')) {
      final prefixLength =
          entry.textForLanguage(state.sourceLanguage).length - 3;
      final extra = input.substring(prefixLength).trim();
      return baseTranslation + (extra.isNotEmpty ? ' $extra' : '');
    }
    return baseTranslation;
  }

  TranslatorState _buildSwappedState(
    TranslatorState previousState, {
    bool closeDropdown = false,
  }) {
    final hasTranslation =
        previousState.status == TranslationStatus.success &&
        previousState.translatedText.trim().isNotEmpty;

    return previousState.copyWith(
      sourceLanguage: previousState.targetLanguage,
      targetLanguage: previousState.sourceLanguage,
      inputText: hasTranslation
          ? previousState.translatedText
          : previousState.inputText,
      translatedText: hasTranslation ? previousState.inputText : '',
      status: hasTranslation
          ? TranslationStatus.success
          : TranslationStatus.idle,
      isDropdownOpen: closeDropdown ? false : previousState.isDropdownOpen,
    );
  }
}
