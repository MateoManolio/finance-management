import '../../domain/entity/category.dart';

class Income {
  final int id;
  final double value;
  final String? note;
  final DateTime time;
  final Category category;

  Income({
    this.id = 0,
    required this.value,
    this.note,
    required this.time,
    required this.category,
  });
}
