import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/expense_dao.dart';
import '../models/credit_card_dao.dart';
import '../models/subscription_dao.dart';
import 'objectbox/objectbox.g.dart';

class AppDB {
  late final Store expenseStore;

  late final Box<ExpenseDao> movieBox;
  late final Box<CreditCardDao> creditCardBox;
  late final Box<SubscriptionDao> subscriptionBox;

  AppDB._create(this.expenseStore) {
    movieBox = Box<ExpenseDao>(expenseStore);
    creditCardBox = Box<CreditCardDao>(expenseStore);
    subscriptionBox = Box<SubscriptionDao>(expenseStore);
  }

  static Future<AppDB> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final movieStore = await openStore(
      directory: p.join(
        docsDir.path,
        "obx-database",
      ),
    );
    return AppDB._create(movieStore);
  }
}
