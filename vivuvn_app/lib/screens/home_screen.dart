import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Home Screen'),
              ElevatedButton(
                onPressed: () {
                  context.go(loginRoute);
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
