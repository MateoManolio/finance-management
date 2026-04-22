import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/app/data/mappers/expense_mapper.dart';
import 'package:wise_wallet/app/domain/entity/category.dart';
import 'package:wise_wallet/app/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDB _database;

  CategoryRepositoryImpl(this._database);

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final categoriesDao = _database.categoryBox.getAll();
      final categories = categoriesDao
          .map((dao) => CategoryMapper.toDomain(dao))
          .toList()
        ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
      return Right(categories);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, Category>> saveCategory(Category category) async {
    try {
      final dao = CategoryMapper.toDao(category);
      final id = _database.categoryBox.put(dao);
      final savedDao = _database.categoryBox.get(id);
      return Right(CategoryMapper.toDomain(savedDao!));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, Category>> updateCategory(Category category) async {
    return saveCategory(category);
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      _database.categoryBox.remove(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, void>> reorderCategories(
      List<Category> categories) async {
    try {
      final daos = categories.asMap().entries.map((entry) {
        final category = entry.value;
        final updatedCategory = Category(
          id: category.id,
          name: category.name,
          icon: category.icon,
          group: category.group,
          color: category.color,
          parentId: category.parentId,
          displayOrder: entry.key,
        );
        return CategoryMapper.toDao(updatedCategory);
      }).toList();

      _database.categoryBox.putMany(daos);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllCategories() async {
    try {
      _database.categoryBox.removeAll();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }
}
