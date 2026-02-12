import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../domain/entity/expense.dart';

class DisplayExpensesController extends GetxController {
  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'today'.tr;
    } else if (dateToCheck == yesterday) {
      return 'yesterday'.tr;
    } else {
      final monthKeys = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december'
      ];
      final monthName = monthKeys[date.month - 1].tr;
      return 'date_format'.trParams({
        'day': date.day.toString(),
        'month': monthName,
      });
    }
  }

  List<Color> getColorForExpense(Expense expense) {
    final baseColor = expense.getEffectiveColor();
    final darkerColor =
        HSLColor.fromColor(baseColor).withLightness(0.3).toColor();

    return [baseColor, darkerColor];
  }
}
