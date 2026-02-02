import 'package:dartz/dartz.dart';
import '../entity/category.dart';
import '../../core/errors/failures.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, Category>> saveCategory(Category category);
  Future<Either<Failure, Category>> updateCategory(Category category);
  Future<Either<Failure, void>> deleteCategory(int id);
  Future<Either<Failure, void>> reorderCategories(List<Category> categories);
}
