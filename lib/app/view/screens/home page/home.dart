import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_constants.dart';
import '../../../controllers/expenses_controller.dart';
import '../load_expense/load_expense_screen.dart';
import 'widgets/big_button.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/display_expenses.dart';

class Home extends GetView<ExpensesController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customGradient = LinearGradient(
      colors: [
        theme.colorScheme.surface.withValues(
            alpha: theme.brightness == Brightness.light ? 0.6 : 0.1),
        theme.colorScheme.surface.withValues(
            alpha: theme.brightness == Brightness.light ? 0.3 : 0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppConstants.largeRadius),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: AppConstants.defaultBlur,
                      sigmaY: AppConstants.defaultBlur,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: customGradient,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                                alpha: AppConstants.shadowOpacity),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border(
                          bottom: BorderSide(
                            color: theme.colorScheme.onSurface.withValues(
                                alpha: AppConstants.defaultGlassOpacity * 0.5),
                            width: 1,
                          ),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          children: [
                            const DashboardHeader(),
                            Expanded(
                              child: Obx(
                                () => DisplayExpenses(
                                  expenses: controller.expenses.toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
