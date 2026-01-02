import '../entity/subscription.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionsUseCase {
  final SubscriptionRepository _repository;

  GetSubscriptionsUseCase(this._repository);

  Future<List<Subscription>> call() {
    return _repository.getSubscriptions();
  }
}
