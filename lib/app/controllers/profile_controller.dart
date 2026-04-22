import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wise_wallet/app/domain/entity/bank_discount.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/entity/credit_card.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/entity/subscription.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/repositories/bank_discount_repository.dart';
import 'package:wise_wallet/app/domain/repositories/category_repository.dart';
import 'package:wise_wallet/app/domain/repositories/credit_card_repository.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';
import 'package:wise_wallet/app/domain/repositories/subscription_repository.dart';
import 'package:wise_wallet/app/domain/repositories/tag_repository.dart';
import 'package:wise_wallet/app/domain/usecases/get_exchange_rate_usecase.dart';
import 'package:wise_wallet/app/service/auth_service.dart';
import 'package:home_widget/home_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'expenses_controller.dart';
import 'analysis_controller.dart';
import 'cards_controller.dart';
import 'subscriptions_controller.dart';
import 'bank_discounts_controller.dart';

class ProfileController extends GetxController {
  final CategoryRepository _categoryRepository;
  final TagRepository _tagRepository;
  final ExpenseRepository _expenseRepository;
  final CreditCardRepository _creditCardRepository;
  final SubscriptionRepository _subscriptionRepository;
  final BankDiscountRepository _bankDiscountRepository;
  final GetExchangeRateUseCase _getExchangeRateUseCase;
  final AuthService _authService;
  final _storage = GetStorage();

  ProfileController({
    required CategoryRepository categoryRepository,
    required TagRepository tagRepository,
    required ExpenseRepository expenseRepository,
    required CreditCardRepository creditCardRepository,
    required SubscriptionRepository subscriptionRepository,
    required BankDiscountRepository bankDiscountRepository,
    required GetExchangeRateUseCase getExchangeRateUseCase,
    required AuthService authService,
  })  : _categoryRepository = categoryRepository,
        _tagRepository = tagRepository,
        _expenseRepository = expenseRepository,
        _creditCardRepository = creditCardRepository,
        _subscriptionRepository = subscriptionRepository,
        _bankDiscountRepository = bankDiscountRepository,
        _getExchangeRateUseCase = getExchangeRateUseCase,
        _authService = authService;

  // Categories state
  final categories = <Category>[].obs;
  final isLoadingCategories = false.obs;

  // Tags state
  final tags = <Tag>[].obs;
  final isLoadingTags = false.obs;

  // Settings state
  final currency = 'ARS'.obs;
  final exchangeRate = 1.0.obs;
  final language = 'es_ARG'.obs;
  final isDarkMode = true.obs;
  final usePasscode = false.obs;

  // Financial state
  final monthlyIncome = 0.0.obs;
  final balance = 0.0.obs;

  void updateBalance(double totalExpenses) {
    balance.value = monthlyIncome.value - totalExpenses;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    loadCategories();
    loadTags();
    fetchExchangeRate();
  }

  Future<void> fetchExchangeRate() async {
    final result = await _getExchangeRateUseCase.execute();
    result.fold(
      (failure) => null,
      (rate) => exchangeRate.value = rate,
    );
  }

  void _loadSettings() {
    currency.value = _storage.read('currency') ?? 'ARS';
    language.value = _storage.read('language') ?? 'es_ARG';
    isDarkMode.value = _storage.read('isDarkMode') ?? true;
    usePasscode.value = _storage.read('usePasscode') ?? false;
    monthlyIncome.value = _storage.read('monthlyIncome') ?? 0.0;
    // Sync dark mode preference to home widgets
    _syncDarkModeToWidgets();
  }

  void setMonthlyIncome(double val) {
    monthlyIncome.value = val;
    _storage.write('monthlyIncome', val);
    // Trigger balance update in expenses controller if available
    if (Get.isRegistered<ExpensesController>()) {
      updateBalance(Get.find<ExpensesController>().getTotalMonthlyExpenses());
    }
  }

  // --- Category Management ---

  Future<void> loadCategories({bool skipSeeding = false}) async {
    isLoadingCategories.value = true;
    final result = await _categoryRepository.getAllCategories();
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_categories'.tr),
      (list) async {
        if (list.isEmpty && !skipSeeding) {
          await _seedDefaultCategories();
        } else {
          categories.value = list;
        }
      },
    );
    isLoadingCategories.value = false;
  }

  Future<void> _seedDefaultCategories() async {
    final defaultCategories = [
      Category(
          name: 'Comida',
          icon: Icons.fastfood_rounded,
          color: Colors.orange,
          displayOrder: 0),
      Category(
          name: 'Transporte',
          icon: Icons.directions_bus_rounded,
          color: Colors.blue,
          displayOrder: 1),
      Category(
          name: 'Servicios',
          icon: Icons.receipt_long_rounded,
          color: Colors.teal,
          displayOrder: 2),
      Category(
          name: 'Entretenimiento',
          icon: Icons.movie_rounded,
          color: Colors.purple,
          displayOrder: 3),
      Category(
          name: 'Compras',
          icon: Icons.shopping_bag_rounded,
          color: Colors.pink,
          displayOrder: 4),
      Category(
          name: 'Salud',
          icon: Icons.medical_services_rounded,
          color: Colors.red,
          displayOrder: 5),
      Category(
          name: 'Educación',
          icon: Icons.school_rounded,
          color: Colors.indigo,
          displayOrder: 6),
      Category(
          name: 'Otros',
          icon: Icons.more_horiz_rounded,
          color: Colors.grey,
          displayOrder: 7),
    ];

    for (final category in defaultCategories) {
      await _categoryRepository.saveCategory(category);
    }
    // Reload categories after seeding
    final result = await _categoryRepository.getAllCategories();
    result.fold((_) => null, (list) => categories.value = list);
  }

  Future<void> addCategory(Category category) async {
    final result = await _categoryRepository.saveCategory(category);
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_save_category'.tr),
      (saved) {
        categories.add(saved);
        Get.back();
      },
    );
  }

  Future<void> editCategory(Category category) async {
    final result = await _categoryRepository.updateCategory(category);
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_update_category'.tr),
      (updated) {
        final index = categories.indexWhere((c) => c.id == updated.id);
        if (index != -1) {
          categories[index] = updated;
          categories.refresh();
        }
        Get.back();
      },
    );
  }

  Future<void> deleteCategory(int id) async {
    final result = await _categoryRepository.deleteCategory(id);
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_delete_category'.tr),
      (_) => categories.removeWhere((c) => c.id == id),
    );
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    // Split categories into root and subcategories
    final rootCategories = categories.where((c) => c.parentId == null).toList();
    final subcategories = categories.where((c) => c.parentId != null).toList();

    final item = rootCategories.removeAt(oldIndex);
    rootCategories.insert(newIndex, item);

    // Update local list immediately for UI responsiveness
    categories.value = [...rootCategories, ...subcategories];

    // Async DB update
    _categoryRepository.reorderCategories(rootCategories);
  }

  // --- Tag Management ---

  Future<void> loadTags({bool skipSeeding = false}) async {
    isLoadingTags.value = true;
    final result = await _tagRepository.getAllTags();
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_tags'.tr),
      (list) async {
        if (list.isEmpty && !skipSeeding) {
          await _seedDefaultTags();
        } else {
          tags.value = list
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        }
      },
    );
    isLoadingTags.value = false;
  }

  Future<void> _seedDefaultTags() async {
    final defaultTags = [
      Tag(tag: 'Importante', color: const Color(0xFFFF5252), displayOrder: 0),
      Tag(tag: 'Recurrente', color: const Color(0xFF448AFF), displayOrder: 1),
      Tag(tag: 'Necesario', color: const Color(0xFF4CAF50), displayOrder: 2),
      Tag(tag: 'Lujo', color: const Color(0xFFFFD740), displayOrder: 3),
      Tag(tag: 'Opcional', color: const Color(0xFF9E9E9E), displayOrder: 4),
    ];

    for (final tag in defaultTags) {
      await _tagRepository.saveTag(tag);
    }
    // Reload tags after seeding
    final result = await _tagRepository.getAllTags();
    result.fold((_) => null, (list) {
      tags.value = list
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    });
  }

  Future<void> addTag(Tag tag) async {
    final result = await _tagRepository.saveTag(tag);
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_save_tag'.tr),
      (saved) {
        tags.add(saved);
        Get.back();
      },
    );
  }

  Future<void> editTag(Tag tag) async {
    final result = await _tagRepository.updateTag(tag);
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_update_tag'.tr),
      (updated) {
        final index = tags.indexWhere((t) => t.id == updated.id);
        if (index != -1) {
          tags[index] = updated;
          tags.refresh();
        }
        Get.back();
      },
    );
  }

  Future<void> deleteTag(int id) async {
    final result = await _tagRepository.deleteTag(id);
    result.fold(
      (failure) => Get.snackbar('error'.tr, 'error_delete_tag'.tr),
      (_) => tags.removeWhere((t) => t.id == id),
    );
  }

  Future<void> reorderTags(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = tags.removeAt(oldIndex);
    tags.insert(newIndex, item);

    await _tagRepository.reorderTags(tags);
  }

  // --- Settings Management ---

  void changeCurrency(String val) {
    if (currency.value == val) return;
    currency.value = val;
    _storage.write('currency', val);
    fetchExchangeRate();
  }

  String formatValue(double valueInArs) {
    if (currency.value == 'ARS' || exchangeRate.value <= 0) {
      return '\$ ${valueInArs.toStringAsFixed(2)}';
    } else {
      final converted = valueInArs / exchangeRate.value;
      return '\$ ${converted.toStringAsFixed(2)} USD';
    }
  }

  void changeLanguage(String val) {
    language.value = val;
    _storage.write('language', val);
    Get.updateLocale(Locale(val.split('_')[0], val.split('_')[1]));
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _syncDarkModeToWidgets();
  }

  void _syncDarkModeToWidgets() {
    HomeWidget.saveWidgetData<bool>('is_dark_mode', isDarkMode.value);
    HomeWidget.updateWidget(
      androidName: 'FinanceWidgetProvider',
      name: 'FinanceWidgetProvider',
    );
    HomeWidget.updateWidget(
      androidName: 'QuickAddWidgetProvider',
      name: 'QuickAddWidgetProvider',
    );
  }

  Future<void> togglePasscode(bool val) async {
    // Determine the desired state
    if (val == usePasscode.value) return;

    // Authenticate before changing state (either to enable or disable)
    final authenticated = await _authService.authenticate();

    if (authenticated) {
      usePasscode.value = val;
      _storage.write('usePasscode', val);
      Get.snackbar(
          'success'.tr, val ? 'passcode_enabled'.tr : 'passcode_disabled'.tr);
    } else {
      // If auth fails, we need to refresh the UI to revert the switch
      usePasscode.refresh();
      Get.snackbar('error'.tr, 'auth_failed'.tr);
    }
  }

  Future<void> exportData() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final data = <String, dynamic>{};

      // Fetch all data
      final categoriesResult = await _categoryRepository.getAllCategories();
      final tagsResult = await _tagRepository.getAllTags();
      final expensesResult = await _expenseRepository.getAllExpenses();
      final cards = await _creditCardRepository.getCards();
      final subscriptions = await _subscriptionRepository.getSubscriptions();
      final bankDiscountsResult =
          await _bankDiscountRepository.getAllDiscounts();

      data['categories'] = categoriesResult.fold(
          (_) => [], (l) => l.map((e) => _categoryToMap(e)).toList());
      data['tags'] = tagsResult.fold(
          (_) => [], (l) => l.map((e) => _tagToMap(e)).toList());
      data['expenses'] = expensesResult.fold(
          (_) => [], (l) => l.map((e) => _expenseToMap(e)).toList());
      data['cards'] = cards.map((e) => _cardToMap(e)).toList();
      data['subscriptions'] =
          subscriptions.map((e) => _subscriptionToMap(e)).toList();
      data['bank_discounts'] = bankDiscountsResult.fold(
          (_) => [], (l) => l.map((e) => _discountToMap(e)).toList());

      data['export_date'] = DateTime.now().toIso8601String();
      data['app_version'] = '1.0.0';

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);

      // We use a temporary directory for sharing, no permissions needed.
      final directory = await getTemporaryDirectory();
      final fileName =
          'wise_wallet_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(jsonString);

      // Use file_picker to let the user choose where to save
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'save'.tr,
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: utf8.encode(jsonString),
      );

      Get.back(); // Close loading

      if (outputFile != null) {
        // outputFile on Android is a content URI, not a real path.
        // We show a friendly message with the filename and the Downloads folder.
        Get.snackbar(
          'export_success'.tr,
          // Show filename + friendly folder name instead of raw URI
          '${'export_saved_in'.tr} Descargas:\n$fileName',
          duration: const Duration(seconds: 8),
          snackPosition: SnackPosition.BOTTOM,
          mainButton: TextButton(
            onPressed: () async {
              if (Platform.isAndroid) {
                const channel =
                    MethodChannel('ar.com.mate.wisewallet/storage');
                await channel.invokeMethod('openDownloadsFolder');
              }
            },
            child: Text(
              'open'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (Get.isOverlaysOpen) Get.back(); // Close loading if open
      Get.snackbar('error'.tr, 'export_error'.tr);
    }
  }

  Map<String, dynamic> _categoryToMap(Category c) => {
        'id': c.id,
        'name': c.name,
        'icon': c.icon.codePoint,
        'color': c.color?.value,
        'displayOrder': c.displayOrder,
        'parentId': c.parentId,
      };

  Map<String, dynamic> _tagToMap(Tag t) => {
        'id': t.id,
        'tag': t.tag,
        'color': t.color.value,
        'displayOrder': t.displayOrder,
      };

  Map<String, dynamic> _expenseToMap(Expense e) => {
        'id': e.id,
        'value': e.value,
        'note': e.note,
        'time': e.time.toIso8601String(),
        'categoryId': e.category.id,
        'cardId': e.card?.id,
        'customColor': e.customColor?.value,
        'tags': e.tags.map((t) => t.id).toList(),
      };

  Map<String, dynamic> _cardToMap(CreditCard c) => {
        'id': c.id,
        'cardNumber': c.cardNumber,
        'holderName': c.holderName,
        'expiryDate': c.expiryDate,
        'closingDay': c.closingDay,
        'dueDay': c.dueDay,
        'color': c.color.value,
        'type': c.type.toString(),
        'bankName': c.bankName,
      };

  Map<String, dynamic> _subscriptionToMap(Subscription s) => {
        'id': s.id,
        'name': s.name,
        'value': s.value,
        'cycle': s.cycle,
        'nextPaymentDate': s.nextPaymentDate.toIso8601String(),
        'categoryId': s.category.id,
        'cardId': s.card?.id,
        'isAutoPay': s.isAutoPay,
        'taxPercentage': s.taxPercentage,
        'note': s.note,
        'tags': s.tags.map((t) => t.id).toList(),
      };

  Map<String, dynamic> _discountToMap(BankDiscount d) => {
        'id': d.id,
        'bankName': d.bankName,
        'discountPercentage': d.discountPercentage,
        'daysOfWeek': d.daysOfWeek,
        'paymentMethod': d.paymentMethod,
        'expiryDate': d.expiryDate?.toIso8601String(),
        'maxCashback': d.maxCashback,
        'installments': d.installments,
        'bankColor': d.bankColor.value,
        'category': d.category,
        'merchantName': d.merchantName,
        'specificDate': d.specificDate?.toIso8601String(),
        'note': d.note,
      };

  void clearData() {
    bool delExpenses = true;
    bool delCategories = true;
    bool delTags = true;
    bool delCards = true;
    bool delSubscriptions = true;
    bool delDiscounts = true;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('clear_data'.tr),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('select_data_to_delete'.tr),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: Text('expenses_of_month'.tr),
                    value: delExpenses,
                    onChanged: (v) => setState(() => delExpenses = v!),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('categories'.tr),
                    value: delCategories,
                    onChanged: (v) => setState(() => delCategories = v!),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('tags'.tr),
                    value: delTags,
                    onChanged: (v) => setState(() => delTags = v!),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('my_cards'.tr),
                    value: delCards,
                    onChanged: (v) => setState(() => delCards = v!),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('subscriptions'.tr),
                    value: delSubscriptions,
                    onChanged: (v) => setState(() => delSubscriptions = v!),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: Text('bank_discounts'.tr),
                    value: delDiscounts,
                    onChanged: (v) => setState(() => delDiscounts = v!),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('cancel'.tr),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.error,
                  foregroundColor: Get.theme.colorScheme.onError,
                ),
                onPressed: () async {
                  if (delExpenses) await _expenseRepository.deleteAllExpenses();
                  if (delCategories) {
                    await _categoryRepository.deleteAllCategories();
                  }
                  if (delTags) await _tagRepository.deleteAllTags();
                  if (delCards) await _creditCardRepository.deleteAllCards();
                  if (delSubscriptions) {
                    await _subscriptionRepository.deleteAllSubscriptions();
                  }
                  if (delDiscounts) {
                    await _bankDiscountRepository.deleteAllDiscounts();
                  }

                  // Reload data but SKIP re-seeding if we just deleted them
                  if (delCategories) {
                    await loadCategories(skipSeeding: true);
                  }
                  if (delTags) {
                    await loadTags(skipSeeding: true);
                  }

                  // --- Trigger Refreshes in other controllers ---
                  // Note: AnalysisController depends on expenses, so refresh it too
                  if (delExpenses || delCategories || delTags) {
                    if (Get.isRegistered<ExpensesController>()) {
                      await Get.find<ExpensesController>().loadExpenses();
                    }
                    if (Get.isRegistered<AnalysisController>()) {
                      await Get.find<AnalysisController>().refreshData();
                    }
                  }

                  if (delCards && Get.isRegistered<CardsController>()) {
                    Get.find<CardsController>().loadCards();
                  }

                  if (delSubscriptions &&
                      Get.isRegistered<SubscriptionsController>()) {
                    Get.find<SubscriptionsController>().loadSubscriptions();
                  }

                  if (delDiscounts &&
                      Get.isRegistered<BankDiscountsController>()) {
                    await Get.find<BankDiscountsController>().loadDiscounts();
                  }

                  Get.back();
                  Get.snackbar('data_cleared'.tr, 'records_deleted'.tr);
                },
                child: Text('delete'.tr),
              ),
            ],
          );
        },
      ),
    );
  }
}
