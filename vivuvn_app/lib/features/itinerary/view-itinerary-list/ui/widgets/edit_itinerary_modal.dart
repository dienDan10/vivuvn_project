import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routes/routes.dart';
import '../../../update-itinerary/controller/update_itinerary_controller.dart';
import '../../models/itinerary.dart';
import 'delete_confirm_dialog.dart';
import 'leave_confirm_dialog.dart';

class EditItineraryModal extends ConsumerWidget {
  final Itinerary itinerary;
  const EditItineraryModal({super.key, required this.itinerary});

  void _showDeleteConfirmationDialog(final BuildContext context) {
    context.pop();
    showDialog(
      context: context,
      builder: (final BuildContext ctx) {
        return DeleteConfirmDialog(itineraryId: itinerary.id);
      },
    );
  }

  void _editItinerary(final BuildContext context) {
    context.pop();
    context.push(createItineraryDetailRoute(itinerary.id));
  }

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bool isOwner = itinerary.isOwner;
    final updateState = ref.watch(updateItineraryControllerProvider);
    final isLoading = updateState.isLoading;
    
    // Get optimistic value or fallback to actual value
    final optimisticValue = updateState.optimisticIsPublicMap[itinerary.id];
    final isPublic = optimisticValue ?? itinerary.isPublic;
    
    // Clear optimistic state if itinerary has been updated to match optimistic value
    if (optimisticValue != null && optimisticValue == itinerary.isPublic) {
      // Clear optimistic state since actual value now matches
      Future.microtask(() {
        ref
            .read(updateItineraryControllerProvider.notifier)
            .clearOptimisticState(itinerary.id);
      });
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Wrap(
        children: isOwner
            ? [
                ListTile(
                  leading: const Icon(Icons.edit, size: 20.0),
                  title: const Text(
                    'Sửa chuyến đi',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () => _editItinerary(context),
                ),
                ListTile(
                  leading: Icon(
                    isPublic ? Icons.public : Icons.lock_outline,
                    size: 20.0,
                  ),
                  title: Text(
                    isPublic ? 'Công khai' : 'Riêng tư',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  trailing: Switch(
                    value: isPublic,
                    onChanged: isLoading
                        ? null
                        : (final value) {
                            ref
                                .read(updateItineraryControllerProvider.notifier)
                                .updatePrivacyStatusWithOptimistic(
                                  context,
                                  itinerary.id,
                                  value,
                                  itinerary.isPublic,
                                );
                          },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.delete, size: 20.0),
                  title: const Text(
                    'Xóa chuyến đi',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () => _showDeleteConfirmationDialog(context),
                ),
              ]
            : [
                ListTile(
                  leading: Image.asset(
                    'assets/icons/exit_icon.png',
                    width: 20.0,
                    height: 20.0,
                  ),
                  title: const Text(
                    'Rời khỏi chuyến đi này',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (final BuildContext ctx) =>
                          LeaveConfirmDialog(itineraryId: itinerary.id),
                    );
                  },
                ),
              ],
      ),
    );
  }
}
