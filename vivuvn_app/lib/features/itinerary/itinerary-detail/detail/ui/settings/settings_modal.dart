import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../itinerary/view-itinerary-list/ui/widgets/leave_confirm_dialog.dart';
import '../../controller/itinerary_detail_controller.dart';
import 'delete_itinerary_button.dart';
import 'edit_name_button.dart';
import 'invite_button.dart';
import 'privacy_button.dart';

class SettingsModal extends ConsumerWidget {
  final int? itineraryId;
  final BuildContext? parentContext;
  
  const SettingsModal({
    super.key, 
    this.itineraryId,
    this.parentContext,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final isOwner =
        ref.watch(itineraryDetailControllerProvider).itinerary?.isOwner ?? false;
    
    // Sử dụng itineraryId được truyền vào, fallback về controller nếu không có
    final finalItineraryId = itineraryId ?? 
        ref.watch(itineraryDetailControllerProvider).itineraryId;
    
    // Sử dụng parentContext nếu có (từ nơi gọi showModalBottomSheet), 
    // nếu không thì dùng context hiện tại
    final detailScreenContext = parentContext ?? context;
    
    return Stack(
      children: [
        // Background tap area
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        // Modal content
        DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (final context, final scrollController) {
            return GestureDetector(
              onTap: () {}, // Stop propagation
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Title
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Tùy chọn',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    // Options list
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          if (isOwner) ...const [
                            EditNameButton(),
                            PrivacyButton(),
                            InviteButton(),
                            DeleteItineraryButton(),
                          ] else ...[
                            ListTile(
                              leading: Image.asset(
                                'assets/icons/exit_icon.png',
                                width: 20,
                                height: 20,
                              ),
                              title: const Text('Rời khỏi chuyến đi này'),
                              onTap: () {
                                final itineraryIdToLeave = finalItineraryId;
                                
                                // Đóng settings modal trước (dùng context từ builder)
                                Navigator.of(context).pop();
                                
                                if (itineraryIdToLeave != null) {
                                  // Đợi một chút để modal đóng hoàn toàn trước khi show dialog
                                  // Sử dụng detailScreenContext từ outer build method
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    // Kiểm tra mounted và show dialog với context đúng
                                    try {
                                      if (detailScreenContext.mounted) {
                                        showDialog(
                                          context: detailScreenContext,
                                          barrierDismissible: false,
                                          builder: (final dialogContext) => LeaveConfirmDialog(
                                            itineraryId: itineraryIdToLeave,
                                            popToList: true,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      // Nếu có lỗi, thử với root navigator
                                      try {
                                        showDialog(
                                          context: detailScreenContext,
                                          useRootNavigator: true,
                                          barrierDismissible: false,
                                          builder: (final dialogContext) => LeaveConfirmDialog(
                                            itineraryId: itineraryIdToLeave,
                                            popToList: true,
                                          ),
                                        );
                                      } catch (_) {
                                        // Ignore nếu vẫn lỗi
                                      }
                                    }
                                  });
                                } else {
                                  // Nếu itineraryId null, hiển thị lỗi
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (detailScreenContext.mounted) {
                                      ScaffoldMessenger.of(detailScreenContext).showSnackBar(
                                        const SnackBar(
                                          content: Text('Không thể xác định lịch trình'),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

