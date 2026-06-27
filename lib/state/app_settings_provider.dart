import 'package:flutter/material.dart';
import '../l10n/app_text.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController({ThemeMode initialThemeMode = ThemeMode.light})
    : _themeMode = initialThemeMode,
      _locale = const Locale('en') {
    AppLocaleState.setLanguageCode(_locale.languageCode);
  }

  ThemeMode _themeMode;
  Locale _locale;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  Locale get locale => _locale;
  bool get isKhmer => _locale.languageCode == 'km';

  void setDarkMode(bool enabled) {
    final nextMode = enabled ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == nextMode) {
      return;
    }
    _themeMode = nextMode;
    notifyListeners();
  }

  void toggleTheme() => setDarkMode(!isDarkMode);

  void setLocale(Locale locale) {
    if (_locale.languageCode == locale.languageCode) {
      return;
    }
    _locale = locale;
    AppLocaleState.setLanguageCode(locale.languageCode);
    notifyListeners();
  }

  void toggleLanguage() {
    setLocale(isKhmer ? const Locale('en') : const Locale('km'));
  }
}

class AppSettingsScope extends InheritedNotifier<AppSettingsController> {
  const AppSettingsScope({
    super.key,
    required AppSettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppSettingsController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>();
    assert(scope != null, 'AppSettingsScope not found in widget tree.');
    return scope!.notifier!;
  }
}
