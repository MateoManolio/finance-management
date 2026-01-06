import 'package:get/get.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/entity/credit_card.dart';
import 'package:wise_wallet/app/domain/usecases/get_expenses_by_date_range_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_all_expenses_usecase.dart';
import 'package:intl/intl.dart';

class AnalysisController extends GetxController {
  final GetExpensesByDateRangeUseCase getExpensesByDateRangeUseCase;
  final GetAllExpensesUseCase getAllExpensesUseCase;

  AnalysisController({
    required this.getExpensesByDateRangeUseCase,
    required this.getAllExpensesUseCase,
  });

  // State
  final _currentDate = DateTime.now().obs;
  final _monthlyExpenses = <Expense>[].obs;
  final _allExpenses = <Expense>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rx<String?>(null);
  final _isAllTimeView = false.obs;
  final _searchQuery = ''.obs;
  final _showByWeekOfMonth = false.obs;

  // Getters
  DateTime get currentDate => _currentDate.value;
  List<Expense> get expenses =>
      _isAllTimeView.value ? _allExpenses : _monthlyExpenses;
  List<Expense> get allExpenses => _allExpenses;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isAllTimeView => _isAllTimeView.value;
  bool get showByWeekOfMonth => _showByWeekOfMonth.value;

  void toggleWeeklyView() =>
      _showByWeekOfMonth.value = !_showByWeekOfMonth.value;

  String get currentMonthName =>
      DateFormat('MMMM yyyy', 'es_ES').format(_currentDate.value);

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    await Future.wait([
      loadExpensesForMonth(),
      loadAllExpenses(),
    ]);
  }

  void toggleView() {
    _isAllTimeView.value = !_isAllTimeView.value;
  }

  void nextMonth() {
    _currentDate.value =
        DateTime(_currentDate.value.year, _currentDate.value.month + 1);
    loadExpensesForMonth();
  }

  void previousMonth() {
    _currentDate.value =
        DateTime(_currentDate.value.year, _currentDate.value.month - 1);
    loadExpensesForMonth();
  }

  Future<void> loadExpensesForMonth() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    final startDate =
        DateTime(_currentDate.value.year, _currentDate.value.month, 1);
    final endDate =
        DateTime(_currentDate.value.year, _currentDate.value.month + 1, 0);

    final result =
        await getExpensesByDateRangeUseCase.execute(startDate, endDate);

    result.fold(
      (failure) => _errorMessage.value = failure.message,
      (loadedExpenses) => _monthlyExpenses.value = loadedExpenses,
    );

    _isLoading.value = false;
  }

  Future<void> loadAllExpenses() async {
    final result = await getAllExpensesUseCase.execute();
    result.fold(
      (failure) => null, // Ignore for now
      (loadedExpenses) => _allExpenses.value = loadedExpenses,
    );
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  List<Expense> get filteredExpenses {
    if (_searchQuery.value.isEmpty) return expenses;
    return _applyFilter(expenses, _searchQuery.value);
  }

  List<Expense> get globalFilteredExpenses {
    if (_searchQuery.value.isEmpty) return [];
    return _applyFilter(_allExpenses, _searchQuery.value);
  }

  List<Expense> _applyFilter(List<Expense> list, String query) {
    final lowerQuery = query.toLowerCase();
    return list.where((e) {
      final noteMatch = e.note?.toLowerCase().contains(lowerQuery) ?? false;
      final categoryMatch = e.category.name.toLowerCase().contains(lowerQuery);
      final amountMatch = e.value.toString().contains(lowerQuery);
      final dateMatch =
          DateFormat('dd/MM/yyyy').format(e.time).contains(lowerQuery);
      return noteMatch || categoryMatch || amountMatch || dateMatch;
    }).toList();
  }

  double getTotalExpenses() {
    return expenses.fold(0, (sum, item) => sum + item.value);
  }

  double getAllTimeTotal() {
    return _allExpenses.fold(0, (sum, item) => sum + item.value);
  }

  Map<Category, double> getExpensesByCategory() {
    final Map<Category, double> breakdown = {};
    for (var expense in expenses) {
      final category = expense.category;
      breakdown[category] = (breakdown[category] ?? 0) + expense.value;
    }
    return breakdown;
  }

  Map<Tag, double> getExpensesByTag() {
    final Map<Tag, double> breakdown = {};
    for (var expense in expenses) {
      for (var tag in expense.tags) {
        breakdown[tag] = (breakdown[tag] ?? 0) + expense.value;
      }
    }
    return breakdown;
  }

  Map<CreditCard?, double> getExpensesByCard() {
    final Map<CreditCard?, double> breakdown = {};
    for (var expense in expenses) {
      breakdown[expense.card] = (breakdown[expense.card] ?? 0) + expense.value;
    }
    return breakdown;
  }

  /// Comparison data for last 6 months
  Future<List<MapEntry<String, double>>> getMonthlyComparisonData() async {
    final List<MapEntry<String, double>> data = [];
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final startDate = DateTime(date.year, date.month, 1);
      final endDate = DateTime(date.year, date.month + 1, 0);

      final result =
          await getExpensesByDateRangeUseCase.execute(startDate, endDate);
      final total = result.fold(
          (_) => 0.0, (exps) => exps.fold(0.0, (sum, e) => sum + e.value));

      data.add(MapEntry(DateFormat('MMM', 'es_ES').format(date), total));
    }
    return data;
  }

  /// Weekly spending: Sun-Sat
  Map<int, double> getWeeklyBreakdown() {
    final Map<int, double> breakdown = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
      7: 0
    };
    for (var expense in expenses) {
      breakdown[expense.time.weekday] =
          (breakdown[expense.time.weekday] ?? 0) + expense.value;
    }
    return breakdown;
  }

  /// Weekly spending by week number (1-5)
  Map<int, double> getWeekOfMonthBreakdown() {
    final Map<int, double> breakdown = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var expense in expenses) {
      final week = ((expense.time.day - 1) ~/ 7) + 1;
      if (week <= 5) {
        breakdown[week] = (breakdown[week] ?? 0) + expense.value;
      }
    }
    return breakdown;
  }

  List<MapEntry<Category, double>> getSortedExpensesByCategory() {
    final breakdown = getExpensesByCategory();
    final sortedList = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedList;
  }

  List<MapEntry<Tag, double>> getSortedExpensesByTag() {
    final breakdown = getExpensesByTag();
    final sortedList = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedList;
  }
}
