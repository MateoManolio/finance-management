import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';

/// Repository interface for expense operations
/// This follows the Dependency Inversion Principle from SOLID
abstract class ExpenseRepository {
  /// Saves an expense to the database
  /// Returns Either a Failure (left) or the saved Expense with ID (right)
  Future<Either<Failure, Expense>> saveExpense(Expense expense);

  /// Retrieves all expenses from the database
  /// Returns Either a Failure (left) or a List of Expenses (right)
  Future<Either<Failure, List<Expense>>> getAllExpenses();

  /// Retrieves an expense by its ID
  /// Returns Either a Failure (left) or the Expense (right)
  Future<Either<Failure, Expense>> getExpenseById(int id);

  /// Updates an existing expense
  /// Returns Either a Failure (left) or the updated Expense (right)
  Future<Either<Failure, Expense>> updateExpense(Expense expense);

  /// Deletes an expense
  /// Returns Either a Failure (left) or void (right)
  Future<Either<Failure, void>> deleteExpense(int id);

  /// Retrieves expenses filtered by date range
  /// Returns Either a Failure (left) or a List of Expenses (right)
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  /// Deletes all expenses
  /// Returns Either a Failure (left) or void (right)
  Future<Either<Failure, void>> deleteAllExpenses();
}
