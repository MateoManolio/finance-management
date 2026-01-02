import '../entity/credit_card.dart';
import '../repositories/credit_card_repository.dart';

class GetCardsUseCase {
  final CreditCardRepository _repository;

  GetCardsUseCase(this._repository);

  Future<List<CreditCard>> call() {
    return _repository.getCards();
  }
}
