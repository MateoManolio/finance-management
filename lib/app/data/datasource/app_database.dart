import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/expense_dao.dart';
import 'objectbox/objectbox.g.dart';

class AppDB {
  late final Store expenseStore;

  late final Box<ExpenseDao> movieBox;

  AppDB._create(this.expenseStore) {
    movieBox = Box<ExpenseDao>(expenseStore);
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
