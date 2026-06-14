import 'package:flutter/material.dart';

class AppSettingsController extends ChangeNotifier {
  AppSettingsController({ThemeMode initialThemeMode = ThemeMode.light})
    : _themeMode = initialThemeMode;

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    final nextMode = enabled ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == nextMode) {
      return;
    }
    _themeMode = nextMode;
    notifyListeners();
  }

  void toggleTheme() => setDarkMode(!isDarkMode);
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
