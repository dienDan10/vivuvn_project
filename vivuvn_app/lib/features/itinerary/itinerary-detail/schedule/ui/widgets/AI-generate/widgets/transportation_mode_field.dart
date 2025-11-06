import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controller/automically_generate_by_ai_controller.dart';
import '../../../../model/transportation_mode.dart';

/// Widget for selecting transportation mode in the budget step.
/// Shows a bottom modal when tapped to select a transportation mode.
/// The selection is required.
class TransportationModeField extends ConsumerWidget {
  const TransportationModeField({super.key});

  Future<void> _openTransportationModal(final BuildContext context, final WidgetRef ref) async {
    final currentMode = ref.read(
      automicallyGenerateByAiControllerProvider.select(
        (final s) => s.transportationMode,
      ),
    );

    await showModalBottomSheet<String?>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (final ctx) {
        final theme = Theme.of(ctx);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                ),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Text(
                      'Chọn phương tiện',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
                // Transportation options
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: TransportationMode.all.length,
                    itemBuilder: (final context, final index) {
                      final mode = TransportationMode.all[index];
                      final isSelected = currentMode == mode;
                      final icon = TransportationMode.getIcon(mode);

                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withValues(
                              alpha: isSelected ? 0.3 : 0.1,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                        title: Text(mode),
                        trailing: isSelected
                            ? Icon(Icons.check, color: theme.colorScheme.primary)
                            : null,
                        selected: isSelected,
                        onTap: () {
                          ref
                              .read(automicallyGenerateByAiControllerProvider.notifier)
                              .setTransportationMode(mode);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final theme = Theme.of(context);
    final transportationMode = ref.watch(
      automicallyGenerateByAiControllerProvider.select(
        (final s) => s.transportationMode,
      ),
    );

    return InkWell(
      onTap: () => _openTransportationModal(context, ref),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Phương tiện di chuyển *',
          hintText: 'Nhấn để chọn',
          border: InputBorder.none,
        ),
        child: Row(
          children: [
            if (transportationMode != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    TransportationMode.getIcon(transportationMode),
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            Expanded(
              child: Text(
                transportationMode ?? 'Chưa chọn',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: transportationMode == null
                      ? theme.colorScheme.onSurfaceVariant
                      : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

