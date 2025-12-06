import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';

/// Use case for retrieving all expenses
/// Following Clean Architecture principles
class GetAllExpensesUseCase {
  final ExpenseRepository _repository;

  GetAllExpensesUseCase(this._repository);

  /// Executes the use case to get all expenses
  ///
  /// Returns Either a [Failure] (left) or a List of [Expense] (right)
  Future<Either<Failure, List<Expense>>> execute() async {
    return await _repository.getAllExpenses();
  }

  /// Convenience method to call execute
  Future<Either<Failure, List<Expense>>> call() async {
    return await execute();
  }
}
