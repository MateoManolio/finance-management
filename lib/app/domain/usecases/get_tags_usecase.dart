import 'package:dartz/dartz.dart';
import '../repositories/tag_repository.dart';
import '../entity/tag.dart';
import '../../core/errors/failures.dart';

class GetTagsUseCase {
  final TagRepository _repository;

  GetTagsUseCase(this._repository);

  Future<Either<Failure, List<Tag>>> execute() {
    return _repository.getAllTags();
  }
}
