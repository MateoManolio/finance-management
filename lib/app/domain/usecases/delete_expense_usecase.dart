import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';

/// Use case for deleting an expense
/// Following Clean Architecture principles
class DeleteExpenseUseCase {
  final ExpenseRepository _repository;

  DeleteExpenseUseCase(this._repository);

  /// Executes the use case to delete an expense
  ///
  /// [id] The ID of the expense to delete
  ///
  /// Returns Either a [Failure] (left) or void (right)
  Future<Either<Failure, void>> execute(int id) async {
    return await _repository.deleteExpense(id);
  }

  /// Convenience method to call execute
  Future<Either<Failure, void>> call(int id) async {
    return await execute(id);
  }
}
