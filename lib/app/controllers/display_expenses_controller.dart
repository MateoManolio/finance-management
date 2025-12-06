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
      return 'Hoy';
    } else if (dateToCheck == yesterday) {
      return 'Ayer';
    } else {
      const months = [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre'
      ];
      return '${date.day} de ${months[date.month - 1]}';
    }
  }

  List<Color> getColorForExpense(Expense expense) {
    final baseColor = expense.getEffectiveColor();
    final darkerColor =
        HSLColor.fromColor(baseColor).withLightness(0.3).toColor();

    return [baseColor, darkerColor];
  }
}
