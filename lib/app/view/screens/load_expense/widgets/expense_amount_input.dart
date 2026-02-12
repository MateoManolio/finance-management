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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'amount'.tr.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.6),
                letterSpacing: 1.2,
              ),
            ),
            Obx(() => GestureDetector(
                  onTap: controller.toggleCurrency,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3)),
                    ),
                    child: Text(
                      controller.selectedCurrency.value,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                )),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller.amountController,
          focusNode: controller.amountFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) =>
              controller.update(), // Trigger UI update for conversion
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.3),
            ),
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.attach_money,
              color: theme.colorScheme.tertiary,
              size: 28,
            ),
          ),
        ),
        // Conversion Preview
        Obx(() {
          if (controller.selectedCurrency.value == 'ARS') {
            return const SizedBox.shrink();
          }

          if (controller.isFetchingRate.value) {
            return const Padding(
              padding: EdgeInsets.only(left: 12),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white54),
              ),
            );
          }

          if (controller.conversionError.value != null) {
            return Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                controller.conversionError.value!,
                style:
                    GoogleFonts.outfit(fontSize: 12, color: Colors.redAccent),
              ),
            );
          }

          final amount =
              double.tryParse(controller.amount.value.replaceAll(',', '.')) ??
                  0;
          final converted = amount * controller.exchangeRate.value;

          return Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                const Icon(Icons.swap_horiz_rounded,
                    size: 16, color: Colors.white54),
                const SizedBox(width: 4),
                Text(
                  '≈ ARS ${converted.toStringAsFixed(2)}',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(1 USD = ${controller.exchangeRate.value.toStringAsFixed(2)})',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
