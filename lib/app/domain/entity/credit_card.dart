import 'package:flutter/material.dart';

enum CardType {
  credit,
  debit,
}

class CreditCard {
  final int id;
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final int closingDay;
  final int dueDay;
  final Color color;
  final CardType type;
  final String? bankName;

  CreditCard({
    this.id = 0,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.closingDay,
    required this.dueDay,
    required this.color,
    required this.type,
    this.bankName,
  });
}
