import 'package:objectbox/objectbox.dart';

@Entity()
class CreditCardDao {
  @Id()
  int id = 0;

  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final int closingDay;
  final int dueDay;
  final int color;
  final int cardType; // 0: Credit, 1: Debit

  CreditCardDao({
    this.id = 0,
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.closingDay,
    required this.dueDay,
    required this.color,
    required this.cardType,
  });
}
