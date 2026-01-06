import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/analysis_controller.dart';

class ViewToggle extends StatelessWidget {
  final AnalysisController controller;

  const ViewToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() => GestureDetector(
          onTap: controller.toggleView,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: controller.isAllTimeView
                  ? theme.colorScheme.primary.withValues(alpha: .1)
                  : theme.colorScheme.surface.withValues(alpha: .5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.isAllTimeView
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: .2),
              ),
            ),
            child: Text(
              controller.isAllTimeView ? 'Mensual' : 'Todo el tiempo',
              style: theme.textTheme.labelLarge?.copyWith(
                color: controller.isAllTimeView
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}
