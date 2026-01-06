import 'package:flutter/material.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/tag.dart';
import '../../domain/entity/credit_card.dart';

class Subscription {
  final int id;
  final String name;
  final double value;
  final String cycle;
  final DateTime nextPaymentDate;
  final Category category;
  final List<Tag> tags;
  final bool isAutoPay;
  final double taxPercentage;
  final String? note;
  final CreditCard? card; // Optional card

  Subscription({
    this.id = 0,
    required this.name,
    required this.value,
    required this.cycle,
    required this.nextPaymentDate,
    required this.category,
    required this.tags,
    required this.isAutoPay,
    required this.taxPercentage,
    this.note,
    this.card,
  });

  Color get color => category.color ?? Colors.blue;
  double get totalValue => value + (value * (taxPercentage / 100));
}
