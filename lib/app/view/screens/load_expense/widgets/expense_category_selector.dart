import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/load_expense_controller.dart';

class ExpenseCategorySelector extends StatelessWidget {
  const ExpenseCategorySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.availableCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final category = controller.availableCategories[index];
              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value == category;
                return GestureDetector(
                  onTap: () => controller.selectedCategory.value = category,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 65,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category.color?.withValues(alpha: 0.3)
                          : Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? category.color ?? Colors.white
                            : Colors.white.withValues(alpha: 0.1),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          color: isSelected
                              ? category.color ?? Colors.white
                              : Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          category.name,
                          style: GoogleFonts.outfit(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 9,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}
