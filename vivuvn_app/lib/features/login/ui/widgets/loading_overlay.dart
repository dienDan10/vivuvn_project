import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final String? loadingText;

  const LoadingOverlay({super.key, this.loadingText});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              if (loadingText != null) ...[
                const SizedBox(height: 16),
                Text(loadingText!, style: const TextStyle(fontSize: 16)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
