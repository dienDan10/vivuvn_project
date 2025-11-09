import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeService extends StateNotifier<ThemeMode> {
  ThemeService() : super(ThemeMode.system);

  void setThemeMode(final ThemeMode mode) {
    state = mode;
  }

  void toggleTheme({final bool? isCurrentlyDark}) {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      // If system mode, toggle based on current brightness
      // If currently dark, switch to light; otherwise switch to dark
      state = (isCurrentlyDark ?? false) ? ThemeMode.light : ThemeMode.dark;
    }
  }

  bool isDarkMode(final BuildContext context) {
    if (state == ThemeMode.light) return false;
    if (state == ThemeMode.dark) return true;
    // For system mode, check the actual brightness
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}

final themeServiceProvider = StateNotifierProvider<ThemeService, ThemeMode>((final ref) {
  return ThemeService();
});

