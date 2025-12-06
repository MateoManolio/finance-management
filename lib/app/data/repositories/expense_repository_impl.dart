import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/app/data/datasource/objectbox/objectbox.g.dart'; // Importante para ExpenseDao_, etc.
import 'package:wise_wallet/app/data/mappers/expense_mapper.dart';
import 'package:wise_wallet/app/data/models/expense_dao.dart';
import 'package:wise_wallet/app/data/models/category_dao.dart';
import 'package:wise_wallet/app/data/models/tag_dao.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';

/// Implementation of ExpenseRepository
/// This is the concrete implementation that uses ObjectBox
class ExpenseRepositoryImpl implements ExpenseRepository {
  final AppDB _database;

  // Boxes for direct access
  late final Box<ExpenseDao> _expenseBox;
  late final Box<CategoryDao> _categoryBox;
  late final Box<TagDao> _tagBox;

  ExpenseRepositoryImpl(this._database) {
    _expenseBox = _database.movieBox;
    _categoryBox = Box<CategoryDao>(_database.expenseStore);
    _tagBox = Box<TagDao>(_database.expenseStore);
  }

  @override
  Future<Either<Failure, Expense>> saveExpense(Expense expense) async {
    try {
      // Validate expense before saving
      final validationResult = _validateExpense(expense);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // Save or get existing category
      final categoryDao = await _saveOrGetCategory(expense.category);

      // Save or get existing tags
      final tagDaos = await _saveOrGetTags(expense.tags);

      // Create expense DAO
      final expenseDao = ExpenseMapper.toDao(expense);

      // Set relationships
      expenseDao.category.target = categoryDao;
      expenseDao.tags.addAll(tagDaos);

      // Save to database
      final id = _expenseBox.put(expenseDao);

      // Retrieve the saved expense to ensure we have the ID
      final savedDao = _expenseBox.get(id);
      if (savedDao == null) {
        return const Left(
          DatabaseFailure(
            message: 'Failed to retrieve saved expense',
            code: 'SAVE_FAILED',
          ),
        );
      }

      // Convert back to domain model
      final savedExpense = ExpenseMapper.toDomain(savedDao);

      return Right(savedExpense);
    } on ObjectBoxException catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Error saving expense: ${e.toString()}',
          code: 'OBJECTBOX_ERROR',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Unexpected error saving expense: $e',
          code: 'UNEXPECTED_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getAllExpenses() async {
    try {
      final expenseDaos = _expenseBox.getAll();
      final expenses =
          expenseDaos.map((dao) => ExpenseMapper.toDomain(dao)).toList();

      return Right(expenses);
    } on ObjectBoxException catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Error retrieving expenses: ${e.toString()}',
          code: 'OBJECTBOX_ERROR',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Unexpected error retrieving expenses: $e',
          code: 'UNEXPECTED_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(int id) async {
    try {
      final expenseDao = _expenseBox.get(id);

      if (expenseDao == null) {
        return Left(
          NotFoundFailure(
            message: 'Expense with ID $id not found',
            code: 'NOT_FOUND',
          ),
        );
      }

      final expense = ExpenseMapper.toDomain(expenseDao);
      return Right(expense);
    } on ObjectBoxException catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Error retrieving expense: ${e.toString()}',
          code: 'OBJECTBOX_ERROR',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Unexpected error retrieving expense: $e',
          code: 'UNEXPECTED_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Expense>> updateExpense(Expense expense) async {
    try {
      // Validate expense before updating
      final validationResult = _validateExpense(expense);
      if (validationResult != null) {
        return Left(validationResult);
      }

      // For update, we need to find an existing expense
      // Since domain Expense doesn't have an ID, we'll need to modify this
      // For now, we'll create a new one (this should be improved)
      return await saveExpense(expense);
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Unexpected error updating expense: $e',
          code: 'UNEXPECTED_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(int id) async {
    try {
      final removed = _expenseBox.remove(id);

      if (!removed) {
        return Left(
          NotFoundFailure(
            message: 'Expense with ID $id not found',
            code: 'NOT_FOUND',
          ),
        );
      }

      return const Right(null);
    } on ObjectBoxException catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Error deleting expense: ${e.toString()}',
          code: 'OBJECTBOX_ERROR',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Unexpected error deleting expense: $e',
          code: 'UNEXPECTED_ERROR',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      // Create query for date range
      final query = _expenseBox
          .query(
            ExpenseDao_.time.greaterOrEqual(startDate.millisecondsSinceEpoch) &
                ExpenseDao_.time.lessOrEqual(endDate.millisecondsSinceEpoch),
          )
          .build();

      final expenseDaos = query.find();
      query.close();

      final expenses =
          expenseDaos.map((dao) => ExpenseMapper.toDomain(dao)).toList();

      return Right(expenses);
    } on ObjectBoxException catch (e) {
      return Left(
        DatabaseFailure(
          message: 'Error retrieving expenses by date range: ${e.toString()}',
          code: 'OBJECTBOX_ERROR',
        ),
      );
    } catch (e) {
      return Left(
        UnexpectedFailure(
          message: 'Unexpected error retrieving expenses by date range: $e',
          code: 'UNEXPECTED_ERROR',
        ),
      );
    }
  }

  // Private helper methods

  /// Validates expense data before saving
  ValidationFailure? _validateExpense(Expense expense) {
    if (expense.value <= 0) {
      return const ValidationFailure(
        message: 'Expense value must be greater than 0',
        code: 'INVALID_VALUE',
      );
    }

    if (expense.category.name.isEmpty) {
      return const ValidationFailure(
        message: 'Category name cannot be empty',
        code: 'INVALID_CATEGORY',
      );
    }

    return null;
  }

  /// Saves category or retrieves existing one if it already exists
  Future<CategoryDao> _saveOrGetCategory(
    Category category,
  ) async {
    // Check if category already exists
    final query =
        _categoryBox.query(CategoryDao_.name.equals(category.name)).build();

    final existingCategories = query.find();
    query.close();

    if (existingCategories.isNotEmpty) {
      return existingCategories.first;
    }

    // Save new category
    final categoryDao = CategoryMapper.toDao(category);
    _categoryBox.put(categoryDao);

    return categoryDao;
  }

  /// Saves tags or retrieves existing ones if they already exist
  Future<List<TagDao>> _saveOrGetTags(List<Tag> tags) async {
    final tagDaos = <TagDao>[];

    for (final tag in tags) {
      // Check if tag already exists
      final query = _tagBox.query(TagDao_.tag.equals(tag.tag)).build();

      final existingTags = query.find();
      query.close();

      if (existingTags.isNotEmpty) {
        tagDaos.add(existingTags.first);
      } else {
        // Save new tag
        final tagDao = TagMapper.toDao(tag);
        _tagBox.put(tagDao);
        tagDaos.add(tagDao);
      }
    }

    return tagDaos;
  }
}
