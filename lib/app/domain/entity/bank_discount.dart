import 'package:flutter/material.dart';

class BankDiscount {
  final int id;
  final String bankName;
  final double discountPercentage;
  final List<int> daysOfWeek; // 1 (Monday) to 7 (Sunday)
  final String paymentMethod;
  final DateTime? expiryDate;
  final double? maxCashback;
  final String? installments;
  final Color bankColor;
  final String? category;
  final String?
      merchantName; // Where it applies (e.g. "Vea", "Comercios Adheridos")
  final DateTime? specificDate; // For one-time discounts

  final String? note;

  BankDiscount({
    this.id = 0,
    required this.bankName,
    required this.discountPercentage,
    required this.daysOfWeek,
    required this.paymentMethod,
    this.expiryDate,
    this.maxCashback,
    this.installments,
    required this.bankColor,
    this.category,
    this.merchantName,
    this.specificDate,
    this.note,
  });

  bool isActiveToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If there's an expiry date and it has passed, it's not active
    if (expiryDate != null && today.isAfter(expiryDate!)) {
      return false;
    }

    // If it's a specific date discount
    if (specificDate != null) {
      final specific =
          DateTime(specificDate!.year, specificDate!.month, specificDate!.day);
      return today.isAtSameMomentAs(specific);
    }

    // Otherwise check days of week
    return daysOfWeek.contains(now.weekday);
  }
}
