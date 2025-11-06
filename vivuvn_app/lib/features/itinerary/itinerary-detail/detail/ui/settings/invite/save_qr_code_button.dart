import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controller/itinerary_detail_controller.dart';
import 'qr_code_save_widget.dart';

class SaveQrCodeButton extends ConsumerStatefulWidget {
  const SaveQrCodeButton({super.key});

  @override
  ConsumerState<SaveQrCodeButton> createState() => _SaveQrCodeButtonState();
}

class _SaveQrCodeButtonState extends ConsumerState<SaveQrCodeButton> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  void _handleSaveQrCode() {
    ref
        .read(itineraryDetailControllerProvider.notifier)
        .saveQrCodeToGallery(context, _repaintBoundaryKey);
  }

  @override
  Widget build(final BuildContext context) {
    // Lấy inviteCode và isSavingQrCode từ state
    final inviteCode = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.inviteCode ?? state.itinerary?.inviteCode,
      ),
    );

    final isSaving = ref.watch(
      itineraryDetailControllerProvider.select(
        (final state) => state.isSavingQrCode,
      ),
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Widget ẩn để capture - đặt ngoài màn hình nhưng vẫn được render
        if (inviteCode != null)
          Positioned(
            left: -9999,
            top: -9999,
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.01, // Gần như trong suốt nhưng vẫn được render
                child: SizedBox(
                  width: 400,
                  height: 500,
                  child: RepaintBoundary(
                    key: _repaintBoundaryKey,
                    child: QrCodeSaveWidget(qrData: inviteCode),
                  ),
                ),
              ),
            ),
          ),
        // Nút lưu
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: inviteCode == null || isSaving ? null : _handleSaveQrCode,
            icon: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.download, color: Colors.white),
            label: Text(isSaving ? 'Đang lưu...' : 'Lưu QR Code'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

