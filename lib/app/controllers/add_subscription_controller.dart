import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/entity/category.dart';
import '../domain/entity/tag.dart';
import '../domain/entity/credit_card.dart';
import '../domain/entity/subscription.dart';
import '../domain/usecases/save_subscription_usecase.dart';
import 'subscriptions_controller.dart';

class AddSubscriptionController extends GetxController {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  final taxController = TextEditingController(); // Tax percentage

  final RxString renewalCycle = 'Mensual'.obs;

  // Replaced paymentDay with nextPaymentDate
  final Rx<DateTime> nextPaymentDate = DateTime.now().obs;

  final Rx<Category?> selectedCategory = Rx<Category?>(null);
  final Rx<CreditCard?> selectedCard = Rx<CreditCard?>(
      null); // Null implies generic/cash, but usually subs are card based.
  final RxList<Tag> selectedTags = <Tag>[].obs;

  final RxBool isAutoPay = true.obs;
  final RxDouble taxPercentage = 0.0.obs;

  final modalHeight = 0.85.obs;
  double _dragStartHeight = 0.85;

  // Data Sources (Ideally from a Repository)
  // We'll init these similar to LoadExpenseController for now
  late List<Category> availableCategories;
  late List<Tag> availableTags;

  @override
  void onInit() {
    super.onInit();
    // Initialize data - For now, we can instantiate a temporary LoadExpenseController to steal its data
    // Or better, define it here. Let's define a few defaults to ensure it works.
    _initData();

    // Listen to tax input
    taxController.addListener(() {
      final val = double.tryParse(taxController.text);
      if (val != null) {
        taxPercentage.value = val;
      } else {
        taxPercentage.value = 0.0;
      }
    });
  }

  void _initData() {
    // Copying simplified logic for demo. In real app, fetch from Repo.
    availableCategories = [
      Category(
          name: 'Comida',
          icon: Icons.fastfood_rounded,
          group: 'Comida y Bebida',
          color: Colors.orange),
      Category(
          name: 'Transporte',
          icon: Icons.directions_car_rounded,
          group: 'Transporte',
          color: Colors.blue),
      Category(
          name: 'Entretenimiento',
          icon: Icons.movie_rounded,
          group: 'Entretenimiento',
          color: Colors.pink),
      Category(
          name: 'Servicios',
          icon: Icons.bolt_rounded,
          group: 'Hogar',
          color: Colors.yellow),
      // Add more as needed
    ];
    if (availableCategories.isNotEmpty) {
      selectedCategory.value =
          availableCategories[2]; // Default to Entertainment
    }

    availableTags = [
      Tag(tag: 'Mensual', color: Colors.blue),
      Tag(tag: 'Anual', color: Colors.orange),
      Tag(tag: 'Trial', color: Colors.green),
    ];
  }

  void onDragStart(DragStartDetails details) {
    _dragStartHeight = modalHeight.value;
  }

  void onDragUpdate(DragUpdateDetails details, double screenHeight) {
    final delta = -details.delta.dy / screenHeight;
    modalHeight.value = (_dragStartHeight + delta).clamp(0.3, 0.95);
  }

  void updateDate(DateTime date) {
    nextPaymentDate.value = date;
  }

  void toggleTag(Tag tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      selectedTags.add(tag);
    }
  }

  void saveSubscription() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter name and price',
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
      return;
    }

    if (selectedCategory.value == null) {
      Get.snackbar('Error', 'Please select a category',
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
      return;
    }

    final price = double.tryParse(priceController.text) ?? 0.0;

    final subscription = Subscription(
      name: nameController.text,
      value: price,
      cycle: renewalCycle.value,
      nextPaymentDate: nextPaymentDate.value,
      category: selectedCategory.value!,
      tags: selectedTags.toList(),
      isAutoPay: isAutoPay.value,
      taxPercentage: taxPercentage.value,
      note: noteController.text,
      card: selectedCard.value,
    );

    try {
      final saveUseCase = Get.find<SaveSubscriptionUseCase>();
      await saveUseCase(subscription);

      if (Get.isRegistered<SubscriptionsController>()) {
        Get.find<SubscriptionsController>().loadSubscriptions();
      }

      Get.back();
      Get.snackbar('Success', 'Subscription saved successfully',
          backgroundColor: Colors.green.withValues(alpha: 0.5),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save: $e',
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    noteController.dispose();
    taxController.dispose();
    super.onClose();
  }
}
