import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../domain/entity/expense.dart';
import '../domain/entity/tag.dart';
import '../domain/entity/category.dart';
import 'expenses_controller.dart';

class LoadExpenseController extends GetxController {
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final amountFocusNode = FocusNode();
  final selectedDate = DateTime.now().obs;
  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final Rx<Color?> customColor = Rx<Color?>(null);
  final selectedTags = <Tag>[].obs;

  // Modal State
  final modalHeight = 0.7.obs;
  double _dragStartHeight = 0.7;

  // Last used date (persists between form resets, but not app restarts)
  DateTime? _lastUsedDate;

  // Dependencies
  final ExpensesController _expensesController = Get.find<ExpensesController>();

  // Available Categories with groups
  final List<Category> availableCategories = [
    // Comida y Bebida
    Category(
      name: 'Comida',
      icon: Icons.fastfood_rounded,
      group: 'Comida y Bebida',
      color: Colors.orange,
    ),
    Category(
      name: 'Café',
      icon: Icons.local_cafe_rounded,
      group: 'Comida y Bebida',
      color: Colors.brown,
    ),
    // Compras
    Category(
      name: 'Compras',
      icon: Icons.shopping_bag_rounded,
      group: 'Compras',
      color: Colors.purple,
    ),
    // Transporte
    Category(
      name: 'Transporte',
      icon: Icons.directions_car_rounded,
      group: 'Transporte',
      color: Colors.blue,
    ),
    Category(
      name: 'Vuelo',
      icon: Icons.flight_rounded,
      group: 'Transporte',
      color: Colors.lightBlue,
    ),
    // Hogar
    Category(
      name: 'Hogar',
      icon: Icons.home_rounded,
      group: 'Hogar',
      color: Colors.green,
    ),
    // Salud y Fitness
    Category(
      name: 'Gimnasio',
      icon: Icons.fitness_center_rounded,
      group: 'Salud y Fitness',
      color: Colors.red,
    ),
    Category(
      name: 'Médico',
      icon: Icons.medical_services_rounded,
      group: 'Salud y Fitness',
      color: Colors.redAccent,
    ),
    // Entretenimiento
    Category(
      name: 'Cine',
      icon: Icons.movie_rounded,
      group: 'Entretenimiento',
      color: Colors.pink,
    ),
    // Educación
    Category(
      name: 'Educación',
      icon: Icons.school_rounded,
      group: 'Educación',
      color: Colors.indigo,
    ),
  ];

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

  final List<Tag> availableTags = [
    Tag(tag: 'Personal', color: Colors.blue),
    Tag(tag: 'Work', color: Colors.orange),
    Tag(tag: 'Family', color: Colors.green),
  ];

  @override
  void onInit() {
    super.onInit();
    resetForm();
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    amountFocusNode.dispose();
    super.onClose();
  }

  void resetForm() {
    // Clear text controllers
    amountController.clear();
    noteController.clear();

    // Reset to first category
    if (availableCategories.isNotEmpty) {
      selectedCategory.value = availableCategories[0];
    }

    // Clear tags and custom color
    selectedTags.clear();
    customColor.value = null;

    // Reset modal height
    modalHeight.value = 0.7;
    _dragStartHeight = 0.7;

    // Set date: use last used date if available, otherwise today
    if (_lastUsedDate != null) {
      selectedDate.value = _lastUsedDate!;
    } else {
      selectedDate.value = DateTime.now();
    }
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
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
        'Error',
        'Please enter a valid amount',
        backgroundColor: Colors.red.withValues(alpha: 0.5),
        colorText: Colors.white,
      );
      return;
    }

    // Validar que haya una categoría seleccionada
    if (selectedCategory.value == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        backgroundColor: Colors.red.withValues(alpha: 0.5),
        colorText: Colors.white,
      );
      return;
    }

    final expense = Expense(
      value: amount,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      time: selectedDate.value,
      tags: selectedTags.toList(),
      category: selectedCategory.value!,
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
      return 'Hoy';
    } else if (dateToCheck == yesterday) {
      return 'Ayer';
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }
}
