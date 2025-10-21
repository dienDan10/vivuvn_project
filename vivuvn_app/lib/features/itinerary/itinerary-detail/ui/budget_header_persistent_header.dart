import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../budget/controller/budget_controller.dart';
import '../budget/ui/widgets/budget_control.dart';
import '../budget/ui/widgets/budget_header.dart';

class BudgetHeaderPersistentHeader extends ConsumerWidget {
  const BudgetHeaderPersistentHeader({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final budget = ref.watch(
      budgetControllerProvider.select((final state) => state.budget),
    );

    if (budget == null) {
      return const SliverToBoxAdapter();
    }

    final screenHeight = MediaQuery.of(context).size.height;

    var height = screenHeight * 0.25;

    if (budget.estimatedBudget > 0) {
      height += 50.0;
    }

    return SliverPersistentHeader(
      pinned: true,
      delegate: _BudgetHeaderDelegate(
        height: height,
        child: const Column(children: [BudgetHeader(), BudgetControl()]),
      ),
    );
  }
}

class _BudgetHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _BudgetHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    final BuildContext context,
    final double shrinkOffset,
    final bool overlapsContent,
  ) {
    return Material(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(final _BudgetHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
