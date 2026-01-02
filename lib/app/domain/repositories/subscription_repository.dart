import '../entity/subscription.dart';

abstract class SubscriptionRepository {
  Future<void> saveSubscription(Subscription subscription);
  Future<List<Subscription>> getSubscriptions();
}
