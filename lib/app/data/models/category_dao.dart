import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryDao {
  int id = 0;
  final String name;
  final int iconCodePoint;
  final String? group;
  final int? color;

  CategoryDao({
    required this.name,
    required this.iconCodePoint,
    this.group,
    this.color,
  });
}
