import 'package:objectbox/objectbox.dart';

@Entity()
class Tag {
  int id = 0;
  final String tag;
  final String color;

  Tag({required this.tag, required this.color});
}
