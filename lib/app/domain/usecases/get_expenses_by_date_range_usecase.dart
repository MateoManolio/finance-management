import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';

/// Use case for retrieving expenses by date range
/// Following Clean Architecture principles
class GetExpensesByDateRangeUseCase {
  final ExpenseRepository _repository;

  GetExpensesByDateRangeUseCase(this._repository);

  /// Executes the use case to get expenses within a date range
  ///
  /// [startDate] The start date of the range
  /// [endDate] The end date of the range
  ///
  /// Returns Either a [Failure] (left) or a List of [Expense] (right)
  Future<Either<Failure, List<Expense>>> execute(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Validate date range
    if (startDate.isAfter(endDate)) {
      return const Left(
        ValidationFailure(
          message: 'Start date must be before end date',
          code: 'INVALID_DATE_RANGE',
        ),
      );
    }

    return await _repository.getExpensesByDateRange(startDate, endDate);
  }

  /// Convenience method to call execute
  Future<Either<Failure, List<Expense>>> call(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await execute(startDate, endDate);
  }
}
