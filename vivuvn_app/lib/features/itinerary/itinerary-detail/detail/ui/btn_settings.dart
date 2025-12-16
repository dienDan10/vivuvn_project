import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'settings/settings_modal.dart';

class ButtonSettings extends StatelessWidget {
  final bool onAppbar;
  const ButtonSettings({super.key, this.onAppbar = false});

  void _showSettingsModal(final BuildContext context) {
    // Lấy itineraryId từ route parameter trước khi show modal
    // Context này nằm trong cây GoRouter nên có thể lấy được route parameter
    int? itineraryId;
    try {
      final route = GoRouterState.of(context);
      final itineraryIdParam = route.pathParameters['id'];
      itineraryId = itineraryIdParam != null ? int.tryParse(itineraryIdParam) : null;
    } catch (e) {
      // Nếu không lấy được từ route, itineraryId sẽ là null
      // SettingsModal sẽ fallback về controller
      itineraryId = null;
    }
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final modalContext) => SettingsModal(
        itineraryId: itineraryId,
        parentContext: context, // Truyền context của detail screen
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _showSettingsModal(context),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: !onAppbar
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.settings,
          color: !onAppbar
              ? theme.colorScheme.onPrimary
              : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
