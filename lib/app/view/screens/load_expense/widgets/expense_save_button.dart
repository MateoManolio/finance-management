import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';

class ExpenseSaveButton extends StatelessWidget {
  const ExpenseSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: controller.saveExpense,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.tertiary,
              theme.colorScheme.tertiaryContainer,
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Save Transaction',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
