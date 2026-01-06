import '../entity/subscription.dart';
import '../repositories/subscription_repository.dart';

class SaveSubscriptionUseCase {
  final SubscriptionRepository _repository;

  SaveSubscriptionUseCase(this._repository);

  Future<void> call(Subscription subscription) {
    return _repository.saveSubscription(subscription);
  }
}
