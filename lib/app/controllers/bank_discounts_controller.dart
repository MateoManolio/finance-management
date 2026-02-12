import 'package:get/get.dart';
import '../domain/entity/bank_discount.dart';
import '../domain/repositories/bank_discount_repository.dart';

class BankDiscountsController extends GetxController {
  final BankDiscountRepository _repository;

  BankDiscountsController({required BankDiscountRepository repository})
      : _repository = repository;

  final discounts = <BankDiscount>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDiscounts();
  }

  Future<void> loadDiscounts() async {
    isLoading.value = true;
    final result = await _repository.getAllDiscounts();
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (list) => discounts.value = list,
    );
    isLoading.value = false;
  }

  Future<void> addDiscount(BankDiscount discount) async {
    final result = await _repository.saveDiscount(discount);
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (saved) {
        discounts.add(saved);
        Get.back();
      },
    );
  }

  Future<void> updateDiscount(BankDiscount discount) async {
    final result = await _repository.updateDiscount(discount);
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (updated) {
        final index = discounts.indexWhere((d) => d.id == updated.id);
        if (index != -1) {
          discounts[index] = updated;
          discounts.refresh();
        }
        Get.back();
      },
    );
  }

  Future<void> deleteDiscount(int id) async {
    final result = await _repository.deleteDiscount(id);
    result.fold(
      (failure) => Get.snackbar('error'.tr, failure.message),
      (_) => discounts.removeWhere((d) => d.id == id),
    );
  }

  List<BankDiscount> get activeTodayDiscounts {
    return discounts.where((d) => d.isActiveToday()).toList();
  }
}
