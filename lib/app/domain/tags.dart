import 'package:objectbox/objectbox.dart';

import 'tag.dart';

@Entity()
class Tags {
  int id = 0;
  final tags = ToMany<Tag>();

  Tags({List<Tag>? tags});
}
