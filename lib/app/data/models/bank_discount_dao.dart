import 'package:objectbox/objectbox.dart';

@Entity()
class BankDiscountDao {
  @Id()
  int id = 0;

  final String bankName;
  final double discountPercentage;
  final String daysOfWeekCsv; // Comma separated values "1,2,3"
  final String paymentMethod;
  @Property(type: PropertyType.date)
  final DateTime? expiryDate;
  final double? maxCashback;
  final String? installments;
  final int bankColor;
  final String? category;
  final String? merchantName;
  @Property(type: PropertyType.date)
  final DateTime? specificDate;

  final String? note;

  BankDiscountDao({
    this.id = 0,
    required this.bankName,
    required this.discountPercentage,
    required this.daysOfWeekCsv,
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
}
