import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entity/bank_discount.dart';
import '../../domain/repositories/bank_discount_repository.dart';
import '../datasource/app_database.dart';
import '../mappers/bank_discount_mapper.dart';

class BankDiscountRepositoryImpl implements BankDiscountRepository {
  final AppDB _appDB;

  BankDiscountRepositoryImpl(this._appDB);

  @override
  Future<Either<Failure, List<BankDiscount>>> getAllDiscounts() async {
    try {
      final daos = _appDB.bankDiscountBox.getAll();
      return Right(
          daos.map((dao) => BankDiscountMapper.toEntity(dao)).toList());
    } catch (e) {
      return const Left(DatabaseFailure(message: 'Error loading discounts'));
    }
  }

  @override
  Future<Either<Failure, BankDiscount>> saveDiscount(
      BankDiscount discount) async {
    try {
      final dao = BankDiscountMapper.toDao(discount);
      final id = _appDB.bankDiscountBox.put(dao);
      return Right(
          BankDiscountMapper.toEntity(_appDB.bankDiscountBox.get(id)!));
    } catch (e) {
      return const Left(DatabaseFailure(message: 'Error saving discount'));
    }
  }

  @override
  Future<Either<Failure, BankDiscount>> updateDiscount(
      BankDiscount discount) async {
    try {
      final dao = BankDiscountMapper.toDao(discount);
      _appDB.bankDiscountBox.put(dao);
      return Right(discount);
    } catch (e) {
      return const Left(DatabaseFailure(message: 'Error updating discount'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDiscount(int id) async {
    try {
      _appDB.bankDiscountBox.remove(id);
      return const Right(null);
    } catch (e) {
      return const Left(DatabaseFailure(message: 'Error deleting discount'));
    }
  }
}
