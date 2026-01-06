import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/analysis_controller.dart';

class MonthSelector extends StatelessWidget {
  final AnalysisController controller;

  const MonthSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.isAllTimeView) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: controller.previousMonth,
              visualDensity: VisualDensity.compact,
            ),
            Text(
              controller.currentMonthName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: controller.nextMonth,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      );
    });
  }
}
