import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../controllers/profile_controller.dart';
import 'package:wise_wallet/app/controllers/analysis_controller.dart';

class ComparisonChart extends StatelessWidget {
  final AnalysisController controller;

  const ComparisonChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<List<MapEntry<String, double>>>(
      future: controller.getMonthlyComparisonData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final maxVal =
            data.fold(0.0, (max, e) => e.value > max ? e.value : max);

        return Container(
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxVal * 1.2,
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
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < 0 || value.toInt() >= data.length) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        data[value.toInt()].key,
                        style: theme.textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                leftTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: data.asMap().entries.map((e) {
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: e.value.value,
                      color: e.key == data.length - 1
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withValues(alpha: 0.4),
                      width: 16,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.95, 0.95));
      },
    );
  }
}
