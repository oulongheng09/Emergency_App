import 'dart:io';

class AppConstants {
  AppConstants._();

  // static const String _apiBaseUrlFromEnv = String.fromEnvironment(
  //   'API_BASE_URL',
  // );

  static String get apiBaseUrl {
    // if (_apiBaseUrlFromEnv.isNotEmpty) {
    //   return _apiBaseUrlFromEnv;
    // }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3001';
    }
    return 'http://localhost:3001';
  }
}
