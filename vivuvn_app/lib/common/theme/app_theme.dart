import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade the package to version 8.3.0.
///
/// Use it in a [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
// abstract final class AppTheme {
//   // The FlexColorScheme defined light mode ThemeData.
//   static ThemeData light = FlexThemeData.light(
//     // Playground built-in scheme made with FlexSchemeColor.from() API.
//     colors: FlexSchemeColor.from(
//       primary: const Color(0xFF065808),
//       brightness: Brightness.light,
//       swapOnMaterial3: true,
//     ),
//     // Component theme configurations for light mode.
//     subThemesData: const FlexSubThemesData(
//       interactionEffects: true,
//       tintedDisabledControls: true,
//       useM2StyleDividerInM3: true,
//       inputDecoratorIsFilled: true,
//       inputDecoratorBorderType: FlexInputBorderType.outline,
//       alignedDropdown: true,
//       navigationRailUseIndicator: true,
//     ),
//     // Direct ThemeData properties.
//     visualDensity: FlexColorScheme.comfortablePlatformDensity,
//     cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
//   );
//
//   // The FlexColorScheme defined dark mode ThemeData.
//   static ThemeData dark = FlexThemeData.dark(
//     // Playground built-in scheme made with FlexSchemeColor.from() API.
//     colors: FlexSchemeColor.from(
//       primary: const Color(0xFF065808),
//       primaryLightRef: const Color(
//         0xFF065808,
//       ), // The color of light mode primary
//       secondaryLightRef: const Color(
//         0xFF365B37,
//       ), // The color of light mode secondary
//       tertiaryLightRef: const Color(
//         0xFF2C7E2E,
//       ), // The color of light mode tertiary
//       brightness: Brightness.dark,
//       swapOnMaterial3: true,
//     ),
//     // Component theme configurations for dark mode.
//     subThemesData: const FlexSubThemesData(
//       interactionEffects: true,
//       tintedDisabledControls: true,
//       blendOnColors: true,
//       useM2StyleDividerInM3: true,
//       inputDecoratorIsFilled: true,
//       inputDecoratorBorderType: FlexInputBorderType.outline,
//       alignedDropdown: true,
//       navigationRailUseIndicator: true,
//     ),
//     // Direct ThemeData properties.
//     visualDensity: FlexColorScheme.comfortablePlatformDensity,
//     cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
//   );
// }

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// AppTheme defines light and dark themes for the app
/// using FlexColorScheme v8.
abstract final class AppTheme {
  // Light Theme
  static ThemeData light = FlexThemeData.light(
    colors: FlexSchemeColor.from(
      primary: const Color(0xFFD32F2F), // Đỏ chủ đạo
      secondary: const Color(0xFFB00020), // Vàng
      tertiary: const Color(0xFFFFCDD2), // Hồng nhạt
      brightness: Brightness.light,
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  ).copyWith(
    scaffoldBackgroundColor: null, // để gradient tự vẽ
    extensions: <ThemeExtension<dynamic>>[
      const GradientBackground(
        colors: [
          Color(0xFFFFEBEE), // Hồng nhạt
          Color(0xFFFFF3E0), // Cam nhạt pha vàng
        ],
      ),
    ],
  );

  // Dark Theme
  static ThemeData dark = FlexThemeData.dark(
    colors: FlexSchemeColor.from(
      primary: const Color(0xFFB71C1C), // Đỏ đậm
      secondary: const Color(0xFFFFA000), // Vàng cam
      tertiary: const Color(0xFF8E24AA), // Tím nhẹ
      brightness: Brightness.dark,
    ),
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

/// Custom ThemeExtension để lưu gradient cho background
@immutable
class GradientBackground extends ThemeExtension<GradientBackground> {
  final List<Color> colors;

  const GradientBackground({required this.colors});

  @override
  ThemeExtension<GradientBackground> copyWith({List<Color>? colors}) {
    return GradientBackground(colors: colors ?? this.colors);
  }

  @override
  ThemeExtension<GradientBackground> lerp(
      ThemeExtension<GradientBackground>? other, double t) {
    if (other is! GradientBackground) return this;
    return GradientBackground(
      colors: List<Color>.generate(
        colors.length,
            (i) => Color.lerp(colors[i], other.colors[i], t)!,
      ),
    );
  }
}

