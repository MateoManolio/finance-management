import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/domain/expense.dart';

class ExpensesController extends GetxController {
  // Reactive state
  final _expenses = <Expense>[].obs;

  // Getters - Return RxList for reactive access
  RxList<Expense> get expenses => _expenses;

  // Mock data (should be replaced with repository pattern later)

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  @override
  void onReady() {
    super.onReady();
    _expenses.sort((a, b) => b.time.compareTo(a.time)); // Most recent first
  }

  // Public methods
  void loadExpenses() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final twoDaysAgo = now.subtract(const Duration(days: 2));
    final lastWeek = now.subtract(const Duration(days: 7));

    _expenses.value = [
      Expense(
        value: 15.50,
        note: 'Almuerzo',
        time: now.subtract(const Duration(hours: 2)),
        tags: [],
        color: Colors.green,
        icon: Icons.fastfood_rounded,
      ),
      Expense(
        value: 4.00,
        note: 'Café',
        time: now.subtract(const Duration(hours: 4)),
        tags: [],
        color: Colors.red,
        icon: Icons.local_cafe_rounded,
      ),
      Expense(
        value: 120.00,
        note: 'Supermercado',
        time: yesterday.subtract(const Duration(hours: 1)),
        tags: [],
        color: Colors.blue,
        icon: Icons.shopping_bag_rounded,
      ),
      Expense(
        value: 25.00,
        note: 'Transporte',
        time: yesterday.subtract(const Duration(hours: 5)),
        tags: [],
        color: Colors.yellow,
        icon: Icons.directions_car_rounded,
      ),
      Expense(
        value: 50.00,
        note: 'Cena',
        time: twoDaysAgo,
        tags: [],
        color: Colors.green,
        icon: Icons.fastfood_rounded,
      ),
      Expense(
        value: 200.00,
        note: 'Ropa',
        time: lastWeek,
        tags: [],
        color: Colors.red,
        icon: Icons.shopping_bag_rounded,
      ),
    ];
    // Ensure they are sorted correctly
    _expenses.sort((a, b) => b.time.compareTo(a.time));
  }

  // Business logic methods
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _expenses.sort((a, b) => b.time.compareTo(a.time));
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
  }

  Map<DateTime, List<Expense>> groupExpensesByDay(List<Expense> expensesList) {
    Map<DateTime, List<Expense>> groupedExpenses = {};

    for (var expense in expensesList) {
      DateTime dateWithoutTime =
          DateTime(expense.time.year, expense.time.month, expense.time.day);

      if (!groupedExpenses.containsKey(dateWithoutTime)) {
        groupedExpenses[dateWithoutTime] = [];
      }

      groupedExpenses[dateWithoutTime]!.add(expense);
    }

    return groupedExpenses;
  }

  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.value);
  }
}
