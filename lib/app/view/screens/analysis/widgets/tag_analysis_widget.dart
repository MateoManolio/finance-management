import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:get/get.dart';
import '../../../../controllers/profile_controller.dart';

class TagAnalysisWidget extends StatelessWidget {
  final List<MapEntry<Tag, double>> tagBreakdown;
  final double total;

  const TagAnalysisWidget({
    super.key,
    required this.tagBreakdown,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    if (tagBreakdown.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Gastos por Etiquetas',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: tagBreakdown.length,
            itemBuilder: (context, index) {
              final entry = tagBreakdown[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '#${entry.key.tag}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    Obx(() {
                      final profile = Get.find<ProfileController>();
                      return Text(
                        profile.formatValue(entry.value),
                        style: theme.textTheme.labelSmall,
                      );
                    }),
                  ],
                ),
              ).animate().fadeIn(delay: (index * 100).ms).scale(
                  begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack);
            },
          ),
        ),
      ],
    );
  }
}
