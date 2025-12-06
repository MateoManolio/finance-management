import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';
import '../../../widgets/glass_container.dart';

class ExpenseNoteInput extends StatelessWidget {
  const ExpenseNoteInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NOTE',
          style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 6),
        GlassContainer(
          opacity: 0.05,
          borderRadius: BorderRadius.circular(14),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: TextField(
            controller: controller.noteController,
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'What is this for?',
              hintStyle: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
              border: InputBorder.none,
              icon: Icon(Icons.edit,
                  color: Colors.white.withValues(alpha: 0.6), size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
