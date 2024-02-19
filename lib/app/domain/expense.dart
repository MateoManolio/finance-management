import 'package:wise_wallet/app/domain/tag.dart';

class Expense {
  final double value;
  final String note;

  final DateTime time;
  final List<Tag> tags;

  Expense({
    required this.value,
    required this.note,
    required this.time,
    required this.tags,
  });
}
