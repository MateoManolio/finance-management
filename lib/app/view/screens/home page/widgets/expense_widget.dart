import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/controllers/display_expenses_controller.dart';
import 'package:wise_wallet/app/controllers/profile_controller.dart';

import '../../../../domain/entity/expense.dart';
import 'liquid_glass_card.dart';

class ExpenseWidget extends StatelessWidget {
  final Expense expense;

  const ExpenseWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return LiquidGlassCard(
      child: Row(
        children: [
          _Leading(expense: expense),
          const SizedBox(width: 14),
          Expanded(
            child: _Name(
              name: expense.tags.isNotEmpty
                  ? expense.tags.first.tag
                  : expense.category.name,
              description: expense.note,
            ),
          ),
          _Price(price: expense.value),
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  final Expense expense;

  const _Leading({required this.expense});

  @override
  Widget build(BuildContext context) {
    final colors =
        Get.find<DisplayExpensesController>().getColorForExpense(expense);

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.first.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.first.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          expense.category.icon,
          color: colors.first,
          size: 22,
        ),
      ),
    );
  }
}

class _Name extends StatelessWidget {
  final String name;
  final String? description;

  const _Name({
    required this.name,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            letterSpacing: -0.2,
          ),
        ),
        if (description != null && description!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _Price extends StatelessWidget {
  final double price;
  const _Price({required this.price});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
        final profile = Get.find<ProfileController>();
        return Text(
          '-${profile.formatValue(price)}',
          style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
        );
      });
  }
}
