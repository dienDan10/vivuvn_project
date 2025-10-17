import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';

class GlobalToast {
  static void showErrorToast(
    final BuildContext context, {
    final String? message,
    final String? title,
  }) {
    CherryToast.error(
      title: title != null ? Text(title) : null,
      description: Text(message ?? 'An error occurred'),
      animationDuration: const Duration(milliseconds: 300),
      animationType: AnimationType.fromTop,
      displayCloseButton: true,
      toastPosition: Position.top,
    ).show(context);
  }
}
