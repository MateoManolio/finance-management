import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/expenses_controller.dart';
import 'widgets/big_button.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/display_expenses.dart';

class Home extends GetView<ExpensesController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Force reload to ensure mock data is fresh
    controller.loadExpenses();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              const SafeArea(
                bottom: false,
                child: DashboardHeader(),
              ),
              Expanded(
                flex: 5,
                child: Obx(
                  () => DisplayExpenses(
                    expenses: controller.expenses.toList(),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -50),
                    child: BigButton(
                      value: 50,
                      onTap: _handleAddExpense,
                      leadingIcon: Icons.add,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleAddExpense() {
    // This is where you would navigate to add expense screen
    // For now, just print
    debugPrint('Add expense button pressed');
    // Example: Get.toNamed(Routes.ADD_EXPENSE);
  }
}
