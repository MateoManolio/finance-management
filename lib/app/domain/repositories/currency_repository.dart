import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class CurrencyRepository {
  /// Gets the exchange rate for USD to ARS.
  /// If [date] is provided, it tries to get historical data.
  /// [casa] defaults to 'blue'.
  Future<Either<Failure, double>> getExchangeRate({
    String casa = 'blue',
    DateTime? date,
  });
}
