import 'package:flutter/material.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';

class Expense {
  final int id; // ID único para base de datos (0 si es nuevo)
  final double value;
  final String? note; // Ahora es opcional

  final DateTime time;
  final List<Tag> tags;

  final Category category;
  final Color?
      customColor; // Color personalizado opcional, si no usa el de la categoría

  Expense({
    this.id = 0, // Por defecto 0 (nuevo registro)
    required this.value,
    this.note,
    required this.time,
    required this.tags,
    required this.category,
    this.customColor,
  });

  // Helper para obtener el color efectivo
  Color getEffectiveColor() => customColor ?? category.color ?? Colors.blue;
}
