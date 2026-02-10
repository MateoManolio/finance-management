import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wise_wallet/app/controllers/analysis_controller.dart';
import '../../../../controllers/profile_controller.dart';

class WeeklyAnalysisChart extends StatelessWidget {
  final AnalysisController controller;

  const WeeklyAnalysisChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final isByWeek = controller.showByWeekOfMonth;
      final breakdown = isByWeek
          ? controller.getWeekOfMonthBreakdown()
          : controller.getWeeklyBreakdown();

      final maxVal = breakdown.values.fold(0.0, (max, v) => v > max ? v : max);
      final labels = isByWeek
          ? ['Sem 1', 'Sem 2', 'Sem 3', 'Sem 4', 'Sem 5']
          : ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isByWeek ? 'Gastos por Semana' : 'Gastos por día',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: controller.toggleWeeklyView,
                  icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                  label: Text(
                    isByWeek ? 'Ver Días' : 'Ver Semanas',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => theme.colorScheme.surface,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final profile = Get.find<ProfileController>();
                      return BarTooltipItem(
                        profile.formatValue(rod.toY),
                        TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                maxY: maxVal * 1.2,
                barGroups: breakdown.entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: isByWeek
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.tertiary,
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt() - 1;
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(labels[idx],
                            style: theme.textTheme.labelSmall);
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          )
              .animate(key: ValueKey(isByWeek))
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.05),
        ],
      );
    });
  }
}
