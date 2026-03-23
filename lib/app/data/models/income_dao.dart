import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/data/models/category_dao.dart';

@Entity()
class IncomeDao {
  int id = 0;
  final double value;
  final String? note;
  @Property(type: PropertyType.date)
  final DateTime time;
  final category = ToOne<CategoryDao>();

  IncomeDao({
    required this.value,
    this.note,
    required this.time,
  });
}
