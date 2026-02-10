import 'package:flutter/material.dart';
import '../../domain/entity/credit_card.dart';
import '../models/credit_card_dao.dart';

class CreditCardMapper {
  static CreditCard toEntity(CreditCardDao dao) {
    return CreditCard(
      id: dao.id,
      cardNumber: dao.cardNumber,
      holderName: dao.holderName,
      expiryDate: dao.expiryDate,
      closingDay: dao.closingDay,
      dueDay: dao.dueDay,
      color: Color(dao.color),
      type: CardType.values[dao.cardType],
      bankName: dao.bankName,
    );
  }

  static CreditCardDao toDao(CreditCard entity) {
    return CreditCardDao(
      id: entity.id,
      cardNumber: entity.cardNumber,
      holderName: entity.holderName,
      expiryDate: entity.expiryDate,
      closingDay: entity.closingDay,
      dueDay: entity.dueDay,
      color: entity.color.value,
      cardType: entity.type.index,
      bankName: entity.bankName,
    );
  }
}
