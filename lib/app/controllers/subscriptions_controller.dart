import 'package:get/get.dart';
import '../domain/entity/subscription.dart';
import '../domain/usecases/get_subscriptions_usecase.dart';

class SubscriptionsController extends GetxController {
  final subscriptions = <Subscription>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadSubscriptions();
  }

  void loadSubscriptions() async {
    try {
      isLoading.value = true;
      final usecase = Get.find<GetSubscriptionsUseCase>();
      final result = await usecase();
      subscriptions.assignAll(result);
    } catch (e) {
      print('Error loading subscriptions: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
