import 'package:flutter/material.dart';

class PageTransition {
  static PageRouteBuilder slideInFromBottom(final Widget page) {
    return PageRouteBuilder(
      pageBuilder: (final context, final animation, final secondaryAnimation) =>
          page,
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder:
          (
            final context,
            final animation,
            final secondaryAnimation,
            final child,
          ) {
            const begin = Offset(0.0, 1.0); // Start from bottom
            const end = Offset.zero; // End at current position
            const curve = Curves.easeInOut;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
    );
  }
}
