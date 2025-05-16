import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends GetxService {
  static final langs = [
    '中文',
    'English',
  ];

  static final locales = [
    const Locale('zh'),
    const Locale('en'),
  ];

  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
    GetStorage().write('locale', locale.languageCode);
  }

  Locale _getLocaleFromLanguage(String lang) {
    switch (lang) {
      case '中文':
        return const Locale('zh');
      case 'English':
        return const Locale('en');
      default:
        return const Locale('zh');
    }
  }
}

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDark';

  bool get isDarkMode => _box.read(_key) ?? false;

  void switchTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _box.write(_key, !isDarkMode);
  }
}
