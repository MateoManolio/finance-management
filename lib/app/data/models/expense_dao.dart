import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';
import 'package:wise_wallet/app/data/models/category_dao.dart';

@Entity()
class ExpenseDao {
  int id = 0;
  final double value;
  final String? note;
  @Property(type: PropertyType.date)
  final DateTime time;
  var tags = ToMany<TagDao>();
  final category = ToOne<CategoryDao>(); // Relación con categoría

  ExpenseDao({
    required this.value,
    this.note,
    required this.time,
  });
}
