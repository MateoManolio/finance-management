import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';
import '../../../widgets/glass_container.dart';

class ExpenseDateSelector extends StatelessWidget {
  const ExpenseDateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'date'.tr.toUpperCase(),
          style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            controller.amountFocusNode.unfocus();
            final date = await showDatePicker(
              context: context,
              initialDate: controller.selectedDate.value,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              controller.updateDate(date);
            }
          },
          child: GlassContainer(
            opacity: 0.05,
            borderRadius: BorderRadius.circular(14),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: theme.colorScheme.tertiary, size: 18),
                const SizedBox(width: 10),
                Obx(() => Text(
                      controller.formatDate(controller.selectedDate.value),
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    )),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white54, size: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
