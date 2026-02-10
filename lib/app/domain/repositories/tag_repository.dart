import 'package:dartz/dartz.dart';
import '../entity/tag.dart';
import '../../core/errors/failures.dart';

abstract class TagRepository {
  Future<Either<Failure, List<Tag>>> getAllTags();
  Future<Either<Failure, Tag>> saveTag(Tag tag);
  Future<Either<Failure, Tag>> updateTag(Tag tag);
  Future<Either<Failure, void>> deleteTag(int id);
  Future<Either<Failure, void>> reorderTags(List<Tag> tags);
}
