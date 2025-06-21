import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ThemeService extends GetxService {
  late SharedPreferences _prefs;

  // Observable theme mode
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;

  // Getters for current theme state
  bool get isDark => _themeMode.value == ThemeMode.dark;
  bool get isLight => _themeMode.value == ThemeMode.light;
  bool get isSystem => _themeMode.value == ThemeMode.system;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initSharedPreferences();
    _loadThemeFromPrefs();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _loadThemeFromPrefs() {
    final themeIndex = _prefs.getInt(AppConstants.keyThemeMode) ?? 0;
    _themeMode.value = ThemeMode.values[themeIndex];
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    _themeMode.value = themeMode;
    await _prefs.setInt(AppConstants.keyThemeMode, themeMode.index);
    Get.changeThemeMode(themeMode);
  }

  Future<void> toggleTheme() async {
    if (_themeMode.value == ThemeMode.light) {
      await changeTheme(ThemeMode.dark);
    } else {
      await changeTheme(ThemeMode.light);
    }
  }

  Future<void> setLightTheme() async {
    await changeTheme(ThemeMode.light);
  }

  Future<void> setDarkTheme() async {
    await changeTheme(ThemeMode.dark);
  }

  Future<void> setSystemTheme() async {
    await changeTheme(ThemeMode.system);
  }

  String get currentThemeName {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Yorug\'';
      case ThemeMode.dark:
        return 'Qorong\'u';
      case ThemeMode.system:
        return 'Tizim';
    }
  }

  IconData get currentThemeIcon {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}