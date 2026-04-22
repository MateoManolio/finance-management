import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../domain/entity/expense.dart';
import '../domain/entity/tag.dart';
import '../domain/entity/category.dart';
import '../domain/entity/credit_card.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_tags_usecase.dart';
import '../domain/usecases/get_exchange_rate_usecase.dart';
import 'expenses_controller.dart';
import 'profile_controller.dart';

class LoadExpenseController extends GetxController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetTagsUseCase getTagsUseCase;
  final GetExchangeRateUseCase getExchangeRateUseCase;

  LoadExpenseController({
    required this.getCategoriesUseCase,
    required this.getTagsUseCase,
    required this.getExchangeRateUseCase,
  });

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final amountFocusNode = FocusNode();
  final selectedDate = DateTime.now().obs;
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final Rx<Color?> customColor = Rx<Color?>(null);
  final selectedTags = <Tag>[].obs;

  final amount = ''.obs;
  final selectedCurrency = 'ARS'.obs; // Default
  final exchangeRate = 1.0.obs;
  final isFetchingRate = false.obs;
  final conversionError = Rx<String?>(null);

  // Selected Card (Null represents Cash)
  final Rx<CreditCard?> selectedCard = Rx<CreditCard?>(null);

  // Modal State
  final modalHeight = 0.7.obs;
  double _dragStartHeight = 0.7;

  // Last used date (persists between form resets, but not app restarts)
  DateTime? _lastUsedDate;

  Expense? _expenseToEdit;
  Expense? get expenseToEdit => _expenseToEdit;

  void loadExistingExpense(Expense expense) {
    _expenseToEdit = expense;
    selectedDate.value = expense.time;
    selectedTags.value = List.from(expense.tags);
    selectedCategory.value = expense.category;
    selectedCard.value = expense.card;
    customColor.value = expense.customColor;
    noteController.text = expense.note ?? '';
    modalHeight.value = 0.7;

    selectedCurrency.value = Get.find<ProfileController>().currency.value;

    if (_allCategories.isEmpty) loadCategories();
    if (_allTags.isEmpty) loadTags();

    if (selectedCurrency.value == 'ARS') {
      amountController.text = expense.value == expense.value.truncateToDouble()
          ? expense.value.toInt().toString()
          : expense.value.toStringAsFixed(2);
      amount.value = amountController.text;
      fetchExchangeRate();
    } else {
      amountController.text = '';
      amount.value = '';
      fetchExchangeRate().then((_) {
        double rate = exchangeRate.value > 0 ? exchangeRate.value : 1.0;
        double displayAmount = expense.value / rate;
        amountController.text = displayAmount == displayAmount.truncateToDouble()
            ? displayAmount.toInt().toString()
            : displayAmount.toStringAsFixed(2);
        amount.value = amountController.text;
      });
    }
  }

  // Dependencies
  final ExpensesController _expensesController = Get.find<ExpensesController>();

  // Reactive available data
  final _allCategories = <Category>[].obs;
  final _allTags = <Tag>[].obs;

  // Filtered categories (only daughter categories)
  List<Category> get availableCategories {
    if (_allCategories.isEmpty) return [];

    // Identificamos IDs de categorías que son padres de otras
    final parentIds = _allCategories
        .where((c) => c.parentId != null && c.parentId != 0)
        .map((c) => c.parentId!)
        .toSet();

    // Las categorías seleccionables son aquellas que NO son padres
    return _allCategories.where((c) {
      if (c.id == null || c.id == 0) return true;
      return !parentIds.contains(c.id);
    }).toList();
  }

  List<Tag> get availableTags => _allTags;

  final List<Color> availableColors = [
    Color(Colors.blue.value),
    Color(Colors.red.value),
    Color(Colors.green.value),
    Color(Colors.orange.value),
    Color(Colors.purple.value),
    Color(Colors.teal.value),
    Color(Colors.pink.value),
    Color(Colors.indigo.value),
  ];

  @override
  void onInit() {
    super.onInit();
    selectedCurrency.value = Get.find<ProfileController>().currency.value;
    amountController.addListener(() {
      amount.value = amountController.text;
    });

    ever(_allCategories, (_) {
      if (selectedCategory.value == null && availableCategories.isNotEmpty) {
        selectedCategory.value = availableCategories[0];
      }
    });

    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await loadCategories();
    await loadTags();
    fetchExchangeRate(); // Initial fetch
    resetForm();
  }

  Future<void> loadCategories() async {
    // If ProfileController is already loaded, use its categories
    if (Get.isRegistered<ProfileController>()) {
      final profileCats = Get.find<ProfileController>().categories;
      if (profileCats.isNotEmpty) {
        _allCategories.value = profileCats.toList();
        _initializeSelection();
        return;
      }
    }

    final result = await getCategoriesUseCase.execute();
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_categories'.tr),
      (list) {
        _allCategories.value = list;
        _initializeSelection();
      },
    );
  }

  void _initializeSelection() {
    if (selectedCategory.value == null && availableCategories.isNotEmpty) {
      selectedCategory.value = availableCategories[0];
    }
  }

  Future<void> loadTags() async {
    final result = await getTagsUseCase.execute();
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_tags'.tr),
      (list) {
        _allTags.value = list
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      },
    );
  }

  Future<void> fetchExchangeRate() async {
    isFetchingRate.value = true;
    conversionError.value = null;

    final result = await getExchangeRateUseCase.execute(
      date: selectedDate.value,
    );

    result.fold(
      (failure) {
        exchangeRate.value = 1.0;
        conversionError.value = 'rate_fetch_error'.tr;
      },
      (rate) {
        exchangeRate.value = rate;
      },
    );

    isFetchingRate.value = false;
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    amountFocusNode.dispose();
    super.onClose();
  }

  void resetForm() {
    _expenseToEdit = null;
    // Clear text controllers
    amountController.clear();
    noteController.clear();

    // Reset to first category
    if (availableCategories.isNotEmpty) {
      selectedCategory.value = availableCategories[0];
    } else {
      selectedCategory.value = null;
    }

    // Clear tags and custom color
    selectedTags.clear();
    customColor.value = null;
    selectedCard.value = null; // Default to Cash

    // Reset modal height
    modalHeight.value = 0.7;
    _dragStartHeight = 0.7;

    // Set date: use last used date if available, otherwise today
    if (_lastUsedDate != null) {
      selectedDate.value = _lastUsedDate!;
    } else {
      selectedDate.value = DateTime.now();
    }

    // Sync currency from profile
    selectedCurrency.value = Get.find<ProfileController>().currency.value;
    fetchExchangeRate();
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchExchangeRate(); // Date change might change historical rate
  }

  void toggleCurrency() {
    final amountText = amountController.text.replaceAll(',', '.');
    final currentAmount = double.tryParse(amountText);

    selectedCurrency.value = selectedCurrency.value == 'ARS' ? 'USD' : 'ARS';
    Get.find<ProfileController>().changeCurrency(selectedCurrency.value);

    if (currentAmount != null &&
        exchangeRate.value > 0 &&
        exchangeRate.value != 1.0) {
      double newAmount;
      if (selectedCurrency.value == 'ARS') {
        // USD -> ARS
        newAmount = currentAmount * exchangeRate.value;
      } else {
        // ARS -> USD
        newAmount = currentAmount / exchangeRate.value;
      }
      amountController.text = newAmount == newAmount.truncateToDouble()
          ? newAmount.toInt().toString()
          : newAmount.toStringAsFixed(2); // keep 2 decimals
    }
  }

  void toggleTag(Tag tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void saveExpense() async {
    final amountText = amountController.text.replaceAll(',', '.');
    final amount = double.tryParse(amountText);

    // Solo validar el precio (obligatorio)
    if (amount == null || amount <= 0) {
      Get.snackbar(
        'error'.tr,
        'invalid_amount'.tr,
        backgroundColor: Colors.red.withValues(alpha: 0.5),
        colorText: Colors.white,
      );
      return;
    }

    // Validar que haya una categoría seleccionada
    if (selectedCategory.value == null) {
      Get.snackbar(
        'error'.tr,
        'select_category_error'.tr,
        backgroundColor: Colors.red.withValues(alpha: 0.5),
        colorText: Colors.white,
      );
      return;
    }

    final baseAmount = amount;
    final finalAmount = selectedCurrency.value == 'ARS'
        ? baseAmount
        : baseAmount * exchangeRate.value;

    final expense = Expense(
      id: _expenseToEdit?.id ?? 0,
      value: finalAmount,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      time: selectedDate.value,
      tags: selectedTags.toList(),
      category: selectedCategory.value!,
      card: selectedCard.value,
    );

    // Save expense using the controller's async method
    final success = await _expensesController.saveExpense(expense);

    if (!success) {
      // Error snackbar is already shown by the controller
      return;
    }
    _lastUsedDate = selectedDate.value;

    // Reset form fields but keep the date
    amountController.clear();
    noteController.clear();
    selectedTags.clear();
    customColor.value = null;

    // Reset to first category
    if (availableCategories.isNotEmpty) {
      selectedCategory.value = availableCategories[0];
    }

    selectedCard.value = null;

    Get.back();
  }

  void onDragStart(DragStartDetails details) {
    _dragStartHeight = modalHeight.value;
  }

  void onDragUpdate(DragUpdateDetails details, double screenHeight) {
    final delta = -details.delta.dy / screenHeight;
    modalHeight.value = (_dragStartHeight + delta).clamp(0.3, 0.95);
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'today'.tr;
    } else if (dateToCheck == yesterday) {
      return 'yesterday'.tr;
    } else {
      final monthKeys = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december'
      ];
      final monthName = monthKeys[date.month - 1].tr;
      return 'date_format'.trParams({
        'day': date.day.toString(),
        'month': monthName,
      });
    }
  }
}
