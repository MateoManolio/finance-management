import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/data/models/category_dao.dart';
import 'package:wise_wallet/app/data/models/credit_card_dao.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';

@Entity()
class SubscriptionDao {
  @Id()
  int id = 0;

  final String name;
  final double value;
  final String cycle;
  @Property(type: PropertyType.date)
  final DateTime nextPaymentDate;
  final bool isAutoPay;
  final double taxPercentage;
  final String? note;

  final category = ToOne<CategoryDao>();
  final card = ToOne<CreditCardDao>();
  var tags = ToMany<TagDao>();

  SubscriptionDao({
    this.id = 0,
    required this.name,
    required this.value,
    required this.cycle,
    required this.nextPaymentDate,
    required this.isAutoPay,
    required this.taxPercentage,
    this.note,
  });
}
