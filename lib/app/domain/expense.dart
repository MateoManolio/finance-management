import 'package:flutter/material.dart';
import 'package:wise_wallet/app/domain/tag.dart';

class Expense {
  final double value;
  final String note;

  final DateTime time;
  final List<Tag> tags;

  final Color color;
  final IconData icon;

  Expense({
    required this.value,
    required this.note,
    required this.time,
    required this.tags,
    required this.color,
    required this.icon,
  });
}
