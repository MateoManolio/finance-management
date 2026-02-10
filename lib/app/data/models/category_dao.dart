import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryDao {
  int id = 0;
  final String name;
  final int iconCodePoint;
  final String? group;
  final int? color;
  final int? parentId;
  final int displayOrder;

  CategoryDao({
    required this.name,
    required this.iconCodePoint,
    this.group,
    this.color,
    this.parentId,
    this.displayOrder = 0,
  });
}
