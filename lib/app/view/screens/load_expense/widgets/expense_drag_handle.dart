import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';

class ExpenseDragHandle extends StatelessWidget {
  const ExpenseDragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    // We don't need to find the controller here if we just pass the callbacks,
    // but to keep it fully abstracted as requested:
    final controller = Get.find<LoadExpenseController>();
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragStart: controller.onDragStart,
      onVerticalDragUpdate: (details) =>
          controller.onDragUpdate(details, screenHeight),
      child: Container(
        // Transparent container to expand hit test area if needed,
        // but the Column children provide enough area usually.
        // Adding color: Colors.transparent helps catch events on empty space if needed.
        color: Colors.transparent,
        width: double.infinity,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'save_transaction'.tr,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
