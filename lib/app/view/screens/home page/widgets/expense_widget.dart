import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/controllers/display_expenses_controller.dart';

import '../../../../domain/expense.dart';
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
          const SizedBox(width: 12),
          Expanded(
            child: _Name(
              name:
                  expense.tags.isNotEmpty ? expense.tags.first.tag : 'Expense',
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
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        expense.icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

class _Name extends StatelessWidget {
  final String name;
  final String description;

  const _Name({
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Price extends StatelessWidget {
  final double price;
  const _Price({required this.price});

  @override
  Widget build(BuildContext context) => Text(
        '-\$${price.toStringAsFixed(0)} USD',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFF5F5DC),
            ),
      );
}
