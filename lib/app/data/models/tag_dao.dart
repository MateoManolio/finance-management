import 'package:objectbox/objectbox.dart';

@Entity()
class TagDao {
  int id = 0;
  final String tag;
  final int color;

  TagDao({required this.tag, required this.color});
}
