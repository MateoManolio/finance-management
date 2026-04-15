import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/display_expenses_controller.dart';
import '../../../../core/app_constants.dart';
import '../../../../domain/entity/expense.dart';
import 'expense_widget.dart';

import 'empty_expenses_placeholder.dart';

class DisplayExpenses extends StatelessWidget {
  final List<Expense> expenses;

  const DisplayExpenses({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return _Information(expenses);
  }
}

class _Information extends StatelessWidget {
  final List<Expense> expenses;

  const _Information(this.expenses);

  Map<DateTime, List<Expense>> get _groupedExpenses {
    Map<DateTime, List<Expense>> grouped = {};
    for (var expense in expenses) {
      final date = DateTime(
        expense.time.year,
        expense.time.month,
        expense.time.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(expense);
    }

    final reversedKeys = grouped.keys.toList().reversed;
    return LinkedHashMap.fromIterable(
      reversedKeys,
      key: (date) => date as DateTime,
      value: (date) => grouped[date as DateTime]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const EmptyExpensesPlaceholder();
    }

    final grouped = _groupedExpenses;

    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.white],
          stops: [0.0, 0.15],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.only(
          left: AppConstants.defaultPadding + 4,
          right: AppConstants.defaultPadding + 4,
          top: AppConstants.defaultPadding + 4,
        ),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final date = grouped.keys.elementAt(index);
          final dailyExpenses = grouped[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  Get.find<DisplayExpensesController>().formatDate(date),
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ...dailyExpenses.map((expense) => Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: ExpenseWidget(expense: expense),
                  )),
            ],
          );
        },
      ),
    );
  }
}
