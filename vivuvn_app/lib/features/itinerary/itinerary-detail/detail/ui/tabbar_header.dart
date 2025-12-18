import 'package:flutter/material.dart';

class TabbarHeader extends StatelessWidget {
  final TabController tabController;
  const TabbarHeader({super.key, required this.tabController});

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: LayoutBuilder(
        builder: (final context, final constraints) {
          // Nếu màn hình quá nhỏ (< 400px), hiển thị icon
          final bool showIconOnly = constraints.maxWidth < 400;

          return TabBar(
            controller: tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            labelStyle: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: theme.textTheme.titleSmall,
            tabs: [
              Tab(
                icon: showIconOnly
                    ? const Icon(Icons.dashboard_outlined, size: 22)
                    : null,
                child: showIconOnly
                    ? null
                    : const Text(
                        'Tổng quan',
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              Tab(
                icon: showIconOnly
                    ? const Icon(Icons.map_outlined, size: 22)
                    : null,
                child: showIconOnly
                    ? null
                    : const Text(
                        'Lịch trình',
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              Tab(
                icon: showIconOnly
                    ? const Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 22,
                      )
                    : null,
                child: showIconOnly
                    ? null
                    : const Text(
                        'Ngân sách',
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
              Tab(
                icon: showIconOnly
                    ? const Icon(Icons.people_outline, size: 22)
                    : null,
                child: showIconOnly
                    ? null
                    : const Text(
                        'Thành viên',
                        style: TextStyle(fontSize: 14.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
