import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/app/data/mappers/expense_mapper.dart';
import 'package:wise_wallet/app/domain/entity/tag.dart';
import 'package:wise_wallet/app/domain/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final AppDB _database;

  TagRepositoryImpl(this._database);

  @override
  Future<Either<Failure, List<Tag>>> getAllTags() async {
    try {
      final tagsDao = _database.tagBox.getAll();
      final tags = tagsDao.map((dao) => TagMapper.toDomain(dao)).toList();
      return Right(tags);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, Tag>> saveTag(Tag tag) async {
    try {
      final dao = TagMapper.toDao(tag);
      final id = _database.tagBox.put(dao);
      final savedDao = _database.tagBox.get(id);
      return Right(TagMapper.toDomain(savedDao!));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, Tag>> updateTag(Tag tag) async {
    return saveTag(tag);
  }

  @override
  Future<Either<Failure, void>> deleteTag(int id) async {
    try {
      _database.tagBox.remove(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, void>> reorderTags(List<Tag> tags) async {
    try {
      final daos = tags.asMap().entries.map((entry) {
        final tag = entry.value;
        final updatedTag = Tag(
          id: tag.id,
          tag: tag.tag,
          color: tag.color,
          displayOrder: entry.key,
        );
        return TagMapper.toDao(updatedTag);
      }).toList();

      _database.tagBox.putMany(daos);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllTags() async {
    try {
      _database.tagBox.removeAll();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString(), code: 'DB_ERROR'));
    }
  }
}
