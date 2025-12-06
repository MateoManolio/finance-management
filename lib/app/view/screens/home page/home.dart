import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/expenses_controller.dart';
import '../load_expense/load_expense_screen.dart';
import 'widgets/big_button.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/display_expenses.dart';

class Home extends GetView<ExpensesController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => _handleAddExpense(context),
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

  void _handleAddExpense(BuildContext context) {
    Get.generalDialog(
      barrierColor: Colors.black.withValues(alpha: 0.2),
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      pageBuilder: (context, animation, secondaryAnimation) =>
          const LoadExpenseScreen(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
