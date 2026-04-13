enum TranslationStatus { idle, loading, success, error }

class TranslatorState {
  final String sourceLanguage;
  final String targetLanguage;
  final String inputText;
  final String translatedText;
  final TranslationStatus status;
  final bool isDropdownOpen;
  final bool isSelectingSource; // true = source dropdown, false = target

  const TranslatorState({
    this.sourceLanguage = 'English',
    this.targetLanguage = 'Ralamuli',
    this.inputText = '',
    this.translatedText = '',
    this.status = TranslationStatus.idle,
    this.isDropdownOpen = false,
    this.isSelectingSource = true,
  });

  TranslatorState copyWith({
    String? sourceLanguage,
    String? targetLanguage,
    String? inputText,
    String? translatedText,
    TranslationStatus? status,
    bool? isDropdownOpen,
    bool? isSelectingSource,
  }) {
    return TranslatorState(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      inputText: inputText ?? this.inputText,
      translatedText: translatedText ?? this.translatedText,
      status: status ?? this.status,
      isDropdownOpen: isDropdownOpen ?? this.isDropdownOpen,
      isSelectingSource: isSelectingSource ?? this.isSelectingSource,
    );
  }
}
