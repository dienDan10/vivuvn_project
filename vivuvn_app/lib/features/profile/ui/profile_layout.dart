import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/theme_service.dart';
import 'widgets/profile_info_form.dart';
import 'widgets/profile_menu_items.dart';
import 'widgets/profile_picture_section.dart';

class ProfileLayout extends ConsumerWidget {
  const ProfileLayout({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider);
    final themeService = ref.read(themeServiceProvider.notifier);

    return Scaffold(
      // backgroundColor:
      //     ? const Color(0xFF1E1E1E)
      //     : const Color(0xFFF5F5F5),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              themeService.toggleTheme();
            },
            tooltip: 'Chuyển giao diện',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              // Profile Picture Section
              ProfilePictureSection(),
              SizedBox(height: 30),
              // Profile Info Form
              ProfileInfoForm(),
              SizedBox(height: 40),
              // Menu Items
              ProfileMenuItems(),
            ],
          ),
        ),
      ),
    );
  }
}
