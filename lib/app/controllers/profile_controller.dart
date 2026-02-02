import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/repositories/category_repository.dart';
import 'package:wise_wallet/app/domain/repositories/tag_repository.dart';
import 'package:wise_wallet/app/domain/usecases/get_exchange_rate_usecase.dart';

class ProfileController extends GetxController {
  final CategoryRepository _categoryRepository;
  final TagRepository _tagRepository;
  final GetExchangeRateUseCase _getExchangeRateUseCase;
  final _storage = GetStorage();

  ProfileController({
    required CategoryRepository categoryRepository,
    required TagRepository tagRepository,
    required GetExchangeRateUseCase getExchangeRateUseCase,
  })  : _categoryRepository = categoryRepository,
        _tagRepository = tagRepository,
        _getExchangeRateUseCase = getExchangeRateUseCase;

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
  }

  // --- Category Management ---

  Future<void> loadCategories() async {
    isLoadingCategories.value = true;
    final result = await _categoryRepository.getAllCategories();
    result.fold(
      (failure) =>
          Get.snackbar('Error', 'No se pudieron cargar las categorías'),
      (list) async {
        if (list.isEmpty) {
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
      (failure) => Get.snackbar('Error', 'No se pudo guardar la categoría'),
      (saved) {
        categories.add(saved);
        Get.back();
      },
    );
  }

  Future<void> editCategory(Category category) async {
    final result = await _categoryRepository.updateCategory(category);
    result.fold(
      (failure) => Get.snackbar('Error', 'No se pudo actualizar la categoría'),
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
      (failure) => Get.snackbar('Error', 'No se pudo eliminar la categoría'),
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

  Future<void> loadTags() async {
    isLoadingTags.value = true;
    final result = await _tagRepository.getAllTags();
    result.fold(
      (failure) => Get.snackbar('Error', 'No se pudieron cargar los tags'),
      (list) async {
        if (list.isEmpty) {
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
      (failure) => Get.snackbar('Error', 'No se pudo guardar el tag'),
      (saved) {
        tags.add(saved);
        Get.back();
      },
    );
  }

  Future<void> editTag(Tag tag) async {
    final result = await _tagRepository.updateTag(tag);
    result.fold(
      (failure) => Get.snackbar('Error', 'No se pudo actualizar el tag'),
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
      (failure) => Get.snackbar('Error', 'No se pudo eliminar el tag'),
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
  }

  void togglePasscode(bool val) {
    usePasscode.value = val;
    _storage.write('usePasscode', val);
  }

  void exportData() {
    // Placeholder logic for export
    Get.snackbar('Exportar', 'Exportando datos a JSON...');
  }

  void clearData() {
    // Placeholder logic for clearing data
    Get.defaultDialog(
      title: 'Borrar todo',
      middleText:
          '¿Estás seguro de que quieres borrar todos tus datos? Esta acción es irreversible.',
      textConfirm: 'Borrar',
      textCancel: 'Cancelar',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Implement actual deletion logic
        Get.back();
        Get.snackbar('Datos borrados', 'Se han eliminado todos los registros');
      },
    );
  }
}
