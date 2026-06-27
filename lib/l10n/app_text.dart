import 'package:flutter/material.dart';

import '../state/app_settings_provider.dart';

class AppText {
  AppText._();

  static String t(
    BuildContext context, {
    required String en,
    required String km,
  }) {
    return AppSettingsScope.of(context).isKhmer ? km : en;
  }
}

class AppLocaleState {
  AppLocaleState._();

  static String _languageCode = 'en';

  static String get languageCode => _languageCode;

  static bool get isKhmer => _languageCode == 'km';

  static void setLanguageCode(String languageCode) {
    _languageCode = languageCode.toLowerCase() == 'km' ? 'km' : 'en';
  }
}
