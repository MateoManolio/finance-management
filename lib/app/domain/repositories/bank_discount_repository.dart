import 'package:dartz/dartz.dart';
import '../entity/bank_discount.dart';
import '../../core/errors/failures.dart';

abstract class BankDiscountRepository {
  Future<Either<Failure, List<BankDiscount>>> getAllDiscounts();
  Future<Either<Failure, BankDiscount>> saveDiscount(BankDiscount discount);
  Future<Either<Failure, BankDiscount>> updateDiscount(BankDiscount discount);
  Future<Either<Failure, void>> deleteDiscount(int id);
}
