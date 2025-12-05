import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/display_expenses_controller.dart';
import '../../../../core/app_constants.dart';
import '../../../../domain/expense.dart';
import 'expense_widget.dart';

class DisplayExpenses extends StatelessWidget {
  final List<Expense> expenses;

  const DisplayExpenses({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final customGradient = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: AppConstants.defaultGlassOpacity),
        Colors.white.withValues(alpha: AppConstants.defaultGlassOpacity / 2),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppConstants.largeRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppConstants.defaultBlur,
          sigmaY: AppConstants.defaultBlur,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: customGradient,
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withValues(alpha: AppConstants.shadowOpacity),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border(
              bottom: BorderSide(
                color: Colors.white
                    .withValues(alpha: AppConstants.defaultGlassOpacity),
                width: 1,
              ),
            ),
          ),
          child: _Information(expenses),
        ),
      ),
    );
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
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
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
          // Reverse the list to show oldest to newest (top to bottom within the day)
          final dailyExpenses = grouped[date]!.reversed.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Text(
                  Get.find<DisplayExpensesController>().formatDate(date),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
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
