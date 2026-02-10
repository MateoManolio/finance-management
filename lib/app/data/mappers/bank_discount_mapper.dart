import 'package:flutter/material.dart';
import '../../domain/entity/bank_discount.dart';
import '../models/bank_discount_dao.dart';

class BankDiscountMapper {
  static BankDiscount toEntity(BankDiscountDao dao) {
    return BankDiscount(
      id: dao.id,
      bankName: dao.bankName,
      discountPercentage: dao.discountPercentage,
      daysOfWeek: dao.daysOfWeekCsv
          .split(',')
          .where((s) => s.isNotEmpty)
          .map(int.parse)
          .toList(),
      paymentMethod: dao.paymentMethod,
      expiryDate: dao.expiryDate,
      maxCashback: dao.maxCashback,
      installments: dao.installments,
      bankColor: Color(dao.bankColor),
      category: dao.category,
      merchantName: dao.merchantName,
      specificDate: dao.specificDate,
      note: dao.note,
    );
  }

  static BankDiscountDao toDao(BankDiscount entity) {
    return BankDiscountDao(
      id: entity.id,
      bankName: entity.bankName,
      discountPercentage: entity.discountPercentage,
      daysOfWeekCsv: entity.daysOfWeek.join(','),
      paymentMethod: entity.paymentMethod,
      expiryDate: entity.expiryDate,
      maxCashback: entity.maxCashback,
      installments: entity.installments,
      bankColor: entity.bankColor.value,
      category: entity.category,
      merchantName: entity.merchantName,
      specificDate: entity.specificDate,
      note: entity.note,
    );
  }
}
