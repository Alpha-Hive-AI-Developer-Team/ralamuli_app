import 'package:flutter_riverpod/legacy.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);

class SettingsState {
  final String defaultLanguage;
  final bool isLanguageDropdownOpen;

  const SettingsState({
    this.defaultLanguage = 'English',
    this.isLanguageDropdownOpen = false,
  });

  SettingsState copyWith({
    String? defaultLanguage,
    bool? isLanguageDropdownOpen,
  }) {
    return SettingsState(
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      isLanguageDropdownOpen:
          isLanguageDropdownOpen ?? this.isLanguageDropdownOpen,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  static const List<String> languages = ['English', 'Español', 'Ralamuli'];

  void toggleDropdown() {
    state = state.copyWith(
      isLanguageDropdownOpen: !state.isLanguageDropdownOpen,
    );
  }

  void selectLanguage(String lang) {
    state = state.copyWith(
      defaultLanguage: lang,
      isLanguageDropdownOpen: false,
    );
  }

  void closeDropdown() {
    state = state.copyWith(isLanguageDropdownOpen: false);
  }
}
