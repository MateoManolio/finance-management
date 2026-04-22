import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/expense_dao.dart';
import '../models/credit_card_dao.dart';
import '../models/subscription_dao.dart';
import '../models/category_dao.dart';
import '../models/tag_dao.dart';
import '../models/bank_discount_dao.dart';
import 'objectbox/objectbox.g.dart';

class AppDB {
  late final Store store;

  late final Box<ExpenseDao> expenseBox;
  late final Box<CreditCardDao> creditCardBox;
  late final Box<SubscriptionDao> subscriptionBox;
  late final Box<CategoryDao> categoryBox;
  late final Box<TagDao> tagBox;
  late final Box<BankDiscountDao> bankDiscountBox;

  AppDB._create(this.store) {
    expenseBox = Box<ExpenseDao>(store);
    creditCardBox = Box<CreditCardDao>(store);
    subscriptionBox = Box<SubscriptionDao>(store);
    categoryBox = Box<CategoryDao>(store);
    tagBox = Box<TagDao>(store);
    bankDiscountBox = Box<BankDiscountDao>(store);
  }

  static Future<AppDB> create({bool isTest = false}) async {
    Directory dir;
    if (isTest) {
      dir = await Directory.systemTemp.createTemp('objectbox_test_');
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final store = await openStore(
      directory: p.join(
        dir.path,
        isTest ? "obx-test-database" : "obx-database",
      ),
    );
    return AppDB._create(store);
  }
}
