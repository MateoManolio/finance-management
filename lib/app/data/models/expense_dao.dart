import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';

@Entity()
class ExpenseDao {
  int id = 0;
  final double value;
  final String note;
  @Property(type: PropertyType.date)
  final DateTime time;
  var tags = ToMany<TagDao>();
  final int color;
  final int iconCodePoint;

  ExpenseDao({
    required this.value,
    required this.note,
    required this.time,
    required this.color,
    required this.iconCodePoint,
  });
}
