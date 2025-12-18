import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/secure_storage/secure_storage_provider.dart';

class ThemeService extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  Future<void> initializeThemeMode() async {
    final secureStorage = ref.read(secureStorageProvider);
    final themeMode = await secureStorage.read(key: 'theme_mode');

    if (themeMode == 'light') {
      state = ThemeMode.light;
    } else if (themeMode == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
      // save to storage
      await secureStorage.write(key: 'theme_mode', value: 'light');
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      ref.read(secureStorageProvider).write(key: 'theme_mode', value: 'dark');
    } else {
      state = ThemeMode.light;
      ref.read(secureStorageProvider).write(key: 'theme_mode', value: 'light');
    }
  }

  bool isDarkMode(final BuildContext context) {
    if (state == ThemeMode.light) return false;
    if (state == ThemeMode.dark) return true;
    // For system mode, check the actual brightness
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}

final themeServiceProvider = NotifierProvider<ThemeService, ThemeMode>(
  () => ThemeService(),
);
