import '../entity/credit_card.dart';

abstract class CreditCardRepository {
  Future<void> saveCard(CreditCard card);
  Future<List<CreditCard>> getCards();
}
