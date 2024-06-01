import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:wise_wallet/app/domain/expense.dart';

class ExpensesController extends GetxController {
  final _mockExpense = Expense(
      value: 150, note: 'This is a note', time: DateTime.now(), tags: []);

  late final _mockExpenses = [
    _mockExpense,
    _mockExpense,
    _mockExpense,
    _mockExpense,
    _mockExpense,
    _mockExpense,
    _mockExpense,
    _mockExpense,
  ];

  Map<DateTime, List<Expense>> groupExpensesByDay(List<Expense> expenses) {
    Map<DateTime, List<Expense>> groupedExpenses = {};

    for (var expense in expenses) {
      DateTime dateWithoutTime =
          DateTime(expense.time.year, expense.time.month, expense.time.day);

      if (!groupedExpenses.containsKey(dateWithoutTime)) {
        groupedExpenses[dateWithoutTime] = [];
      }

      groupedExpenses[dateWithoutTime]!.add(expense);
    }

    return groupedExpenses;
  }

  late final List<Expense> expenses;
  @override
  void onInit() {
    expenses = _mockExpenses;
    super.onInit();
  }

  @override
  void onReady() {
    expenses.sort((a, b) => a.time.compareTo(b.time));
  }
}
