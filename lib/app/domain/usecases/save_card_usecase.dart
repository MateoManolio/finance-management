import '../entity/credit_card.dart';
import '../repositories/credit_card_repository.dart';

class SaveCardUseCase {
  final CreditCardRepository _repository;

  SaveCardUseCase(this._repository);

  Future<void> call(CreditCard card) {
    return _repository.saveCard(card);
  }
}
