import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../domain/entity/category.dart';
import '../domain/entity/tag.dart';
import '../domain/entity/credit_card.dart';
import '../domain/entity/subscription.dart';
import '../domain/usecases/save_subscription_usecase.dart';
import '../domain/usecases/get_categories_usecase.dart';
import '../domain/usecases/get_tags_usecase.dart';
import '../domain/usecases/get_exchange_rate_usecase.dart';
import 'subscriptions_controller.dart';
import 'profile_controller.dart';

class AddSubscriptionController extends GetxController {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetTagsUseCase getTagsUseCase;
  final GetExchangeRateUseCase getExchangeRateUseCase;

  AddSubscriptionController({
    required this.getCategoriesUseCase,
    required this.getTagsUseCase,
    required this.getExchangeRateUseCase,
  });

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final noteController = TextEditingController();
  final taxController = TextEditingController(); // Tax percentage

  final RxString price = ''.obs;
  // Currency related
  final selectedCurrency = 'ARS'.obs;
  final exchangeRate = 1.0.obs;
  final isFetchingRate = false.obs;
  final conversionError = Rx<String?>(null);

  final RxString renewalCycle = 'monthly'.obs;

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

  @override
  void onInit() {
    super.onInit();
    selectedCurrency.value = Get.find<ProfileController>().currency.value;
    _loadInitialData();
    fetchExchangeRate();

    priceController.addListener(() {
      price.value = priceController.text;
    });

    ever(_allCategories, (_) {
      if (selectedCategory.value == null && availableCategories.isNotEmpty) {
        selectedCategory.value = availableCategories[0];
      }
    });

    // Listen to tax input
    taxController.addListener(() {
      final val = double.tryParse(taxController.text);
      taxPercentage.value = val ?? 0.0;
    });
  }

  Future<void> fetchExchangeRate() async {
    if (selectedCurrency.value == 'ARS') {
      exchangeRate.value = 1.0;
      return;
    }

    isFetchingRate.value = true;
    conversionError.value = null;

    final result = await getExchangeRateUseCase.execute(
      date: nextPaymentDate.value,
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

  void toggleCurrency() {
    selectedCurrency.value = selectedCurrency.value == 'ARS' ? 'USD' : 'ARS';
    Get.find<ProfileController>().changeCurrency(selectedCurrency.value);
    fetchExchangeRate();
  }

  Future<void> _loadInitialData() async {
    // If ProfileController is already loaded, use its categories
    if (Get.isRegistered<ProfileController>()) {
      final profileCats = Get.find<ProfileController>().categories;
      if (profileCats.isNotEmpty) {
        _allCategories.value = profileCats.toList();
        if (availableCategories.isNotEmpty) {
          selectedCategory.value = availableCategories[0];
        }
      } else {
        await _fetchCategoriesFromSource();
      }
    } else {
      await _fetchCategoriesFromSource();
    }

    final tagResult = await getTagsUseCase.execute();
    tagResult.fold(
      (failure) => Get.snackbar('error'.tr, 'error_tags'.tr),
      (list) {
        _allTags.value = list
          ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      },
    );
  }

  Future<void> _fetchCategoriesFromSource() async {
    final catResult = await getCategoriesUseCase.execute();
    catResult.fold(
      (failure) => Get.snackbar('error'.tr, 'error_categories'.tr),
      (list) {
        _allCategories.value = list;
        if (availableCategories.isNotEmpty) {
          selectedCategory.value = availableCategories[0];
        }
      },
    );
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
      Get.snackbar('error'.tr, 'invalid_amount'.tr,
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
      return;
    }

    if (selectedCategory.value == null) {
      Get.snackbar('error'.tr, 'select_category_error'.tr,
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          colorText: Colors.white);
      return;
    }

    final basePrice = double.tryParse(priceController.text) ?? 0.0;
    final finalPrice = selectedCurrency.value == 'ARS'
        ? basePrice
        : basePrice * exchangeRate.value;

    final subscription = Subscription(
      name: nameController.text,
      value: finalPrice,
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
      Get.snackbar(
          'success'.tr,
          'save_subscription'
              .tr, // Actually maybe a 'saved_success' key? I'll use save_subscription for now
          backgroundColor: Colors.green.withValues(alpha: 0.5),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('error'.tr, 'Failed to save: $e',
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
