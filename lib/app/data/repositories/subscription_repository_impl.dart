import '../../domain/entity/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasource/app_database.dart';
import '../mappers/subscription_mapper.dart';
import '../mappers/credit_card_mapper.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final AppDB _appDB;

  SubscriptionRepositoryImpl(this._appDB);

  @override
  Future<List<Subscription>> getSubscriptions() async {
    final daos = _appDB.subscriptionBox.getAll();
    return daos.map((dao) => SubscriptionMapper.toDomain(dao)).toList();
  }

  @override
  Future<void> saveSubscription(Subscription subscription) async {
    final dao = SubscriptionMapper.toDao(subscription);
    // Since simple mapping creates new objects for relations, we might need to be careful
    // But ObjectBox handles putting relations.
    // Ideally we should check if Category/Tags exist, but following current simple pattern.
    // If Category implementation relies on ID=0 for new, it might duplicate categories if `toDao` returns a new object with ID=0.
    // Let's assume standard behavior for now to match Expense.
    if (subscription.card != null) {
      dao.card.target = CreditCardMapper.toDao(subscription.card!);
    }
    _appDB.subscriptionBox.put(dao);
  }
}
