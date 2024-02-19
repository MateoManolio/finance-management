import 'package:objectbox/objectbox.dart';

@Entity()
class TagDao {
  int id = 0;
  final String tag;
  final String color;

  TagDao({required this.tag, required this.color});
}
