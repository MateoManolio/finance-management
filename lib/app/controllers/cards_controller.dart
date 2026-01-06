import 'package:get/get.dart';
import '../domain/entity/credit_card.dart';
import '../domain/usecases/get_cards_usecase.dart';

class CardsController extends GetxController {
  final cards = <CreditCard>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadCards();
  }

  void loadCards() async {
    try {
      isLoading.value = true;
      final usecase =
          Get.find<GetCardsUseCase>(); // Find it via Service Locator
      final result = await usecase();
      cards.assignAll(result);
    } catch (e) {
      print('Error loading cards: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
