import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';

class ExpenseAmountInput extends StatelessWidget {
  const ExpenseAmountInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AMOUNT',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.6),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.amountController,
          focusNode: controller.amountFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: '\$0.00',
            hintStyle: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.3),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.attach_money,
              color: theme.colorScheme.tertiary,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
