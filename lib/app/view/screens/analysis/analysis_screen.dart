import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wise_wallet/app/controllers/analysis_controller.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'widgets/category_breakdown_item.dart';
import 'widgets/expense_search_delegate.dart';
import 'widgets/comparison_chart.dart';
import 'widgets/month_selector.dart';
import 'widgets/tag_analysis_widget.dart';
import 'widgets/card_analysis_widget.dart';
import 'widgets/total_spent_card.dart';
import 'widgets/view_toggle.dart';
import 'widgets/weekly_analysis_chart.dart';

class AnalysisScreen extends GetView<AnalysisController> {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading && controller.expenses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final total = controller.getTotalExpenses();
          final categoryBreakdown = controller.getSortedExpensesByCategory();
          final tagBreakdown = controller.getSortedExpensesByTag();
          final cardBreakdown = controller.getExpensesByCard();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'financial_dashboard'.tr,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search_rounded),
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: ExpenseSearchDelegate(),
                              );
                            },
                          ).animate().scale(delay: 200.ms),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            MonthSelector(controller: controller),
                            const SizedBox(width: 8),
                            ViewToggle(controller: controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: TotalSpentCard(
                  total: total,
                  isAllTime: controller.isAllTimeView,
                  allTimeTotal: controller.getAllTimeTotal(),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, curve: Curves.easeOutQuad),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: Text(
                          'monthly_comparison'.tr,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ComparisonChart(controller: controller),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms),
              ),
              if (controller.expenses.isEmpty && !controller.isLoading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text('no_expenses_period'.tr),
                    ),
                  ),
                )
              else ...[
                SliverToBoxAdapter(
                  child: WeeklyAnalysisChart(controller: controller)
                      .animate()
                      .fadeIn(delay: 400.ms),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(vertical: 24),
                    child: _buildPieChart(categoryBreakdown, total),
                  ).animate().scale(delay: 500.ms, curve: Curves.elasticOut),
                ),
                SliverToBoxAdapter(
                  child: TagAnalysisWidget(
                    tagBreakdown: tagBreakdown,
                    total: total,
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
                ),
                SliverToBoxAdapter(
                  child: CardAnalysisWidget(cardBreakdown: cardBreakdown)
                      .animate()
                      .fadeIn(delay: 700.ms)
                      .slideX(begin: -0.1),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Text(
                      'category_breakdown'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = categoryBreakdown[index];
                        final percentage =
                            total > 0 ? (entry.value / total) * 100 : 0.0;
                        return CategoryBreakdownItem(
                          category: entry.key,
                          amount: entry.value,
                          percentage: percentage,
                        )
                            .animate()
                            .fadeIn(delay: (800 + (index * 50)).ms)
                            .slideY(begin: 0.1);
                      },
                      childCount: categoryBreakdown.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPieChart(
      List<MapEntry<Category, double>> breakdown, double total) {
    if (total == 0) return const SizedBox.shrink();

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 60,
        startDegreeOffset: -90,
        sections: breakdown.map((entry) {
          final percentage = (entry.value / total) * 100;
          return PieChartSectionData(
            color: entry.key.color ?? Colors.blue,
            value: entry.value,
            title: '${percentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
      ),
    );
  }
}
