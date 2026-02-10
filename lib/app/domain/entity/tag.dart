import 'dart:ui';

class Tag {
  final int? id;
  final String tag;
  final Color color;
  final int displayOrder;

  Tag({
    this.id,
    required this.tag,
    required this.color,
    this.displayOrder = 0,
  });
}
