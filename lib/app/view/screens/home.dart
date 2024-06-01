import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../controllers/expenses_controller.dart';
import '../widget/big_button.dart';
import '../widget/display_expenses.dart';

class Home extends GetView<ExpensesController> {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: DisplayExpenses(
              expenses: controller.expenses,
            ),
          ),
          Expanded(
            flex: 2,
            child: BigButton(
              value: 50,
              onTap: () {
                debugPrint('press');
              },
              leadingIcon: Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
