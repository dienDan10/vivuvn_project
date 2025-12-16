import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

class GlobalToast {
  static void showErrorToast(
    final BuildContext context, {
    final String? message,
    final String? title,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDark ? theme.colorScheme.surfaceContainerHighest : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    CherryToast.error(
      backgroundColor: backgroundColor,
      title: title != null
          ? Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
            )
          : null,
      description: Text(
        message ?? 'An error occurred',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
        ),
      ),
      animationDuration: const Duration(milliseconds: 300),
      animationType: AnimationType.fromTop,
      displayCloseButton: true,
      toastPosition: Position.top,
    ).show(context);
  }

  static void showSuccessToast(
    final BuildContext context, {
    final String? message,
    final String? title,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDark ? theme.colorScheme.surfaceContainerHighest : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    CherryToast.success(
      backgroundColor: backgroundColor,
      title: title != null
          ? Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
              ),
            )
          : null,
      description: message != null
          ? Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
              ),
            )
          : null,
      animationDuration: const Duration(milliseconds: 300),
      animationType: AnimationType.fromTop,
      toastPosition: Position.top,
    ).show(context);
  }
}
