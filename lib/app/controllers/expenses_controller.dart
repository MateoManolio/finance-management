import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/usecases/save_expense_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_all_expenses_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/delete_expense_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_expenses_by_date_range_usecase.dart';

/// Controller for managing expenses
/// Following Clean Architecture and GetX best practices
/// All business operations are delegated to use cases
class ExpensesController extends GetxController {
  // Use Cases - Injected via constructor
  final SaveExpenseUseCase saveExpenseUseCase;
  final GetAllExpensesUseCase getAllExpensesUseCase;
  final DeleteExpenseUseCase deleteExpenseUseCase;
  final GetExpensesByDateRangeUseCase getExpensesByDateRangeUseCase;

  ExpensesController({
    required this.saveExpenseUseCase,
    required this.getAllExpensesUseCase,
    required this.deleteExpenseUseCase,
    required this.getExpensesByDateRangeUseCase,
  });

  // Reactive state
  final _expenses = <Expense>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rx<String?>(null);

  // Getters
  RxList<Expense> get expenses => _expenses;
  RxBool get isLoading => _isLoading;
  Rx<String?> get errorMessage => _errorMessage;

  // Categorías predefinidas para los ejemplos
  final _foodCategory = Category(
    name: 'Comida',
    icon: Icons.fastfood_rounded,
    group: 'Comida y Bebida',
    color: Colors.green,
  );

  final _cafeCategory = Category(
    name: 'Café',
    icon: Icons.local_cafe_rounded,
    group: 'Comida y Bebida',
    color: Colors.red,
  );

  final _shoppingCategory = Category(
    name: 'Compras',
    icon: Icons.shopping_bag_rounded,
    group: 'Compras',
    color: Colors.blue,
  );

  final _transportCategory = Category(
    name: 'Transporte',
    icon: Icons.directions_car_rounded,
    group: 'Transporte',
    color: Colors.yellow,
  );

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  @override
  void onReady() {
    super.onReady();
    _expenses.sort((a, b) => a.time.compareTo(b.time)); // Oldest first
  }

  /// Loads all expenses from the database
  /// Uses GetAllExpensesUseCase to fetch data
  Future<void> loadExpenses() async {
    _setLoading(true);
    _clearError();

    final result = await getAllExpensesUseCase.execute();

    result.fold(
      (failure) {
        // Handle error
        _setError(failure.message);
        // Load mock data as fallback for demo purposes
        _loadMockData();
      },
      (loadedExpenses) {
        // Success - update expenses list
        _expenses.value = loadedExpenses;
        _expenses.sort((a, b) => a.time.compareTo(b.time));
      },
    );

    _setLoading(false);
  }

  /// Saves a new expense to the database
  /// Uses SaveExpenseUseCase
  /// Returns true if successful, false otherwise
  Future<bool> saveExpense(Expense expense) async {
    _setLoading(true);
    _clearError();

    final result = await saveExpenseUseCase.execute(expense);

    bool success = false;

    result.fold(
      (failure) {
        // Handle error
        _setError(failure.message);
        _showErrorSnackbar('Error al guardar', failure.message);
      },
      (savedExpense) {
        // Success - add to list and re-sort
        _expenses.add(savedExpense);
        _expenses.sort((a, b) => a.time.compareTo(b.time));
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Deletes an expense from the database
  /// Note: Expense domain model doesn't have an ID yet
  /// This will need to be updated when the domain model is enhanced
  Future<bool> deleteExpense(int expenseId) async {
    _setLoading(true);
    _clearError();

    final result = await deleteExpenseUseCase.execute(expenseId);

    bool success = false;

    result.fold(
      (failure) {
        // Handle error
        _setError(failure.message);
        _showErrorSnackbar('Error al eliminar', failure.message);
      },
      (_) {
        // Success - remove from list
        // Note: We'll need to reload expenses to properly reflect the change
        loadExpenses();
        showSuccessSnackbar('Gasto eliminado exitosamente');
        success = true;
      },
    );

    _setLoading(false);
    return success;
  }

  /// Gets expenses within a date range
  Future<List<Expense>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    _setLoading(true);
    _clearError();

    final result = await getExpensesByDateRangeUseCase.execute(
      startDate,
      endDate,
    );

    List<Expense> filteredExpenses = [];

    result.fold(
      (failure) {
        // Handle error
        _setError(failure.message);
        _showErrorSnackbar('Error al filtrar gastos', failure.message);
      },
      (expenses) {
        // Success
        filteredExpenses = expenses;
      },
    );

    _setLoading(false);
    return filteredExpenses;
  }

  // Helper methods for display

  /// Groups expenses by day
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

  /// Calculates total expenses
  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.value);
  }

  // Private helper methods

  /// Sets loading state
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  /// Sets error message
  void _setError(String message) {
    _errorMessage.value = message;
  }

  /// Clears error message
  void _clearError() {
    _errorMessage.value = null;
  }

  /// Shows success snackbar
  void showSuccessSnackbar(String message) {
    Get.snackbar(
      'Éxito',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// Shows error snackbar
  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Loads mock data for testing/demo purposes
  /// This is temporary until the database is fully populated
  void _loadMockData() {
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
        category: _foodCategory,
      ),
      Expense(
        value: 4.00,
        note: 'Café',
        time: now.subtract(const Duration(hours: 4)),
        tags: [],
        category: _cafeCategory,
      ),
      Expense(
        value: 120.00,
        note: 'Supermercado',
        time: yesterday.subtract(const Duration(hours: 1)),
        tags: [],
        category: _shoppingCategory,
      ),
      Expense(
        value: 25.00,
        note: 'Transporte',
        time: yesterday.subtract(const Duration(hours: 5)),
        tags: [],
        category: _transportCategory,
      ),
      Expense(
        value: 50.00,
        note: 'Cena',
        time: twoDaysAgo,
        tags: [],
        category: _foodCategory,
      ),
      Expense(
        value: 200.00,
        note: 'Ropa',
        time: lastWeek,
        tags: [],
        category: _shoppingCategory,
      ),
    ];
    _expenses.sort((a, b) => a.time.compareTo(b.time));
  }
}
