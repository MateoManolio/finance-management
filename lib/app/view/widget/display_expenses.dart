import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/domain/expense.dart';
import 'package:wise_wallet/app/view/widget/expense_widget.dart';

class DisplayExpenses extends StatelessWidget {
  final List<Expense> expenses;
  final colors = Get.theme.colorScheme;

  final _customGradient = LinearGradient(
      colors: [
        Get.theme.colorScheme.onSurface,
        Get.theme.colorScheme.primary,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0, 0.3]);

  DisplayExpenses({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          gradient: _customGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _Information(expenses),
        ),
      ),
    );
  }
}

class _Information extends StatelessWidget {
  final List<Expense> expenses;
  static const padding = 8.0;

  const _Information(
    this.expenses,
  );

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Colors.transparent,
            Colors.white,
            Colors.white,
          ],
          stops: [
            0.0,
            0.3,
            0.95,
          ],
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        itemCount: expenses.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: padding),
          child: ExpenseWidget(expense: expenses[index]),
        ),
      ),
    );
  }
}
