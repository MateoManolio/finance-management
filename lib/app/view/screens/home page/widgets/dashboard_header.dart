import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/expenses_controller.dart';
import '../../../../controllers/profile_controller.dart';

class DashboardHeader extends GetView<ExpensesController> {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Main Balance
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'current_balance'.tr.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                final profile = Get.find<ProfileController>();
                return Text(
                  profile.formatValue(profile.balance.value),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    letterSpacing: -1.2,
                  ),
                );
              }),
            ],
          ),
          
          // Right side: Monthly Expenses
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              Obx(() {
                final profile = Get.find<ProfileController>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_upward_rounded,
                          color: Theme.of(context).colorScheme.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.formatValue(profile.monthlyIncome.value),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.formatValue(controller.getTotalMonthlyExpenses()),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 6), // align baseline visually
            ],
          ),
        ],
      ),
    );
  }
}
