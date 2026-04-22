import '../../domain/entity/credit_card.dart';
import '../../domain/repositories/credit_card_repository.dart';
import '../datasource/app_database.dart';
import '../mappers/credit_card_mapper.dart';

class CreditCardRepositoryImpl implements CreditCardRepository {
  final AppDB _appDB;

  CreditCardRepositoryImpl(this._appDB);

  @override
  Future<List<CreditCard>> getCards() async {
    final daos = _appDB.creditCardBox.getAll();
    return daos.map((dao) => CreditCardMapper.toEntity(dao)).toList();
  }

  @override
  Future<void> saveCard(CreditCard card) async {
    final dao = CreditCardMapper.toDao(card);
    _appDB.creditCardBox.put(dao);
  }

  @override
  Future<void> deleteAllCards() async {
    _appDB.creditCardBox.removeAll();
  }
}
