import 'package:dartz/dartz.dart';
import '../repositories/category_repository.dart';
import '../entity/category.dart';
import '../../core/errors/failures.dart';

class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<Category>>> execute() {
    return _repository.getAllCategories();
  }
}
