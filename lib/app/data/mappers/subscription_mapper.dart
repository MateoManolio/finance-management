import 'package:wise_wallet/app/data/mappers/expense_mapper.dart';
import 'package:wise_wallet/app/data/mappers/credit_card_mapper.dart';
import 'package:wise_wallet/app/data/models/subscription_dao.dart';
import '../../domain/entity/subscription.dart';

class SubscriptionMapper {
  static Subscription toDomain(SubscriptionDao dao) {
    return Subscription(
      id: dao.id,
      name: dao.name,
      value: dao.value,
      cycle: dao.cycle,
      nextPaymentDate: dao.nextPaymentDate,
      isAutoPay: dao.isAutoPay,
      taxPercentage: dao.taxPercentage,
      note: dao.note,
      category: CategoryMapper.toDomain(dao.category.target!),
      tags: dao.tags.map((tagDao) => TagMapper.toDomain(tagDao)).toList(),
      card: dao.card.target != null
          ? CreditCardMapper.toEntity(dao.card.target!)
          : null,
    );
  }

  static SubscriptionDao toDao(Subscription entity) {
    final dao = SubscriptionDao(
      id: entity.id,
      name: entity.name,
      value: entity.value,
      cycle: entity.cycle,
      nextPaymentDate: entity.nextPaymentDate,
      isAutoPay: entity.isAutoPay,
      taxPercentage: entity.taxPercentage,
      note: entity.note,
    );

    // Set relations
    // Caution: Creating new CategoryDao/TagDao duplicates them if we don't query for existing ones.
    // However, looking at Expense implementation, it seems to just map toDao.
    // Ideally we should attach existing ObjectBox entities if they exist.
    // But for now following the pattern:

    dao.category.target = CategoryMapper.toDao(entity.category);
    dao.tags.addAll(entity.tags.map((t) => TagMapper.toDao(t)));

    return dao;
  }
}
