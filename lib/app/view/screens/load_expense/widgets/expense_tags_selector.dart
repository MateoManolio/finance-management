import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';

class ExpenseTagsSelector extends StatelessWidget {
  const ExpenseTagsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAGS',
          style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 6),
        Obx(() => Wrap(
              spacing: 6,
              runSpacing: 6,
              children: controller.availableTags.map((tag) {
                final isSelected = controller.selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => controller.toggleTag(tag),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? tag.color.withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? tag.color
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      tag.tag,
                      style: GoogleFonts.outfit(
                        color: isSelected ? tag.color : Colors.white70,
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }
}
