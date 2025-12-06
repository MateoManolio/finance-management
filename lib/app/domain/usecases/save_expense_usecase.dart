import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';

/// Use case for saving an expense
/// Following Clean Architecture principles - Each use case represents a single business operation
///
/// This use case encapsulates the business logic for saving an expense to the repository.
/// It follows the Single Responsibility Principle from SOLID.
class SaveExpenseUseCase {
  final ExpenseRepository _repository;

  SaveExpenseUseCase(this._repository);

  /// Executes the use case to save an expense
  ///
  /// [expense] The expense to save
  ///
  /// Returns Either a [Failure] (left) or the saved [Expense] (right)
  Future<Either<Failure, Expense>> execute(Expense expense) async {
    // Here you can add any additional business logic before saving
    // For example: additional validations, transformations, etc.

    return await _repository.saveExpense(expense);
  }

  /// Convenience method to call execute
  /// This allows using the use case as a callable object: useCase(expense)
  Future<Either<Failure, Expense>> call(Expense expense) async {
    return await execute(expense);
  }
}
