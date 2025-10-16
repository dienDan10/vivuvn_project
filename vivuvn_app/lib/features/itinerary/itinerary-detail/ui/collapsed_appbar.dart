import 'package:flutter/material.dart';

import 'btn_back.dart';
import 'btn_settings.dart';

class CollapsedAppbar extends StatelessWidget {
  const CollapsedAppbar({super.key});

  @override
  Widget build(final BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 12,
        right: 12,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back icon
          ButtonBack(onAppbar: true),

          // Title
          Expanded(
            child: Text(
              'Ngày định mệnh của chúng ta đã đến, giờ đây anh không biết phải làm gì nữa',
              style: TextStyle(color: Colors.black, fontSize: 16),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // setting icon
          ButtonSettings(onAppbar: true),
        ],
      ),
    );
  }
}
