import 'package:dartz/dartz.dart';
import '../repositories/currency_repository.dart';
import '../../core/errors/failures.dart';

class GetExchangeRateUseCase {
  final CurrencyRepository _repository;

  GetExchangeRateUseCase(this._repository);

  Future<Either<Failure, double>> execute(
      {String casa = 'blue', DateTime? date}) {
    return _repository.getExchangeRate(casa: casa, date: date);
  }
}
