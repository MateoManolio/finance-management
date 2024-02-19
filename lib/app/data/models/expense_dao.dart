import 'package:objectbox/objectbox.dart';
import 'package:wise_wallet/app/domain/tags.dart';

@Entity()
class ExpenseDao {
  @Id()
  int id = 0;
  final double value;
  final String note;
  @Property(type: PropertyType.date)
  final DateTime time;
  var tags = ToMany<Tags>();

  ExpenseDao({
    required this.value,
    required this.note,
    required this.time,
  });
}
