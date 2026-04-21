import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/currency_repository.dart';
import '../services/dio_client.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final DioClient _dioClient;

  CurrencyRepositoryImpl(this._dioClient);

  @override
  Future<Either<Failure, double>> getExchangeRate({
    String casa = 'blue',
    DateTime? date,
  }) async {
    try {
      final now = DateTime.now();
      final isToday = date == null ||
          (date.year == now.year &&
              date.month == now.month &&
              date.day == now.day);

      String url;
      if (isToday) {
        url = 'https://dolarapi.com/v1/dolares/$casa';
      } else {
        final formattedDate = DateFormat('yyyy/MM/dd').format(date);
        url =
            'https://api.argentinadatos.com/v1/cotizaciones/dolares/$casa/$formattedDate';
      }

      final response = await _dioClient.get(url);

      if (response.data != null) {
        // Current DolarAPI returns an object with 'compra' and 'venta'
        // ArgentinaDatos historical returns an object with 'compra' and 'venta'
        // We'll use 'venta' (selling price) for conversions of expenses.
        final data = response.data as Map<String, dynamic>;
        final rate = (data['venta'] as num).toDouble();
        return Right(rate);
      } else {
        return const Left(
            NetworkFailure(message: 'Respuesta vacía del servidor'));
      }
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(NetworkFailure(message: 'Error al obtener cotización: $e'));
    }
  }
}
