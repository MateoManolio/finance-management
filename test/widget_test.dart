import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:wise_wallet/app/controllers/expenses_controller.dart';
import 'package:wise_wallet/app/controllers/display_expenses_controller.dart';
import 'package:wise_wallet/app/view/screens/main page/main_screen.dart';
import 'package:wise_wallet/app/domain/usecases/save_expense_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_all_expenses_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/delete_expense_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_expenses_by_date_range_usecase.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import 'package:wise_wallet/app/core/errors/failures.dart';

// Mocks
class MockGetAllExpensesUseCase implements GetAllExpensesUseCase {
  @override
  Future<Either<Failure, List<Expense>>> execute() async => const Right([]);

  @override
  Future<Either<Failure, List<Expense>>> call() async => const Right([]);
}

class MockSaveExpenseUseCase implements SaveExpenseUseCase {
  @override
  Future<Either<Failure, Expense>> execute(Expense expense) async =>
      Right(expense);

  @override
  Future<Either<Failure, Expense>> call(Expense expense) async =>
      Right(expense);
}

class MockDeleteExpenseUseCase implements DeleteExpenseUseCase {
  @override
  Future<Either<Failure, void>> execute(int id) async => const Right(null);

  @override
  Future<Either<Failure, void>> call(int id) async => const Right(null);
}

class MockGetExpensesByDateRangeUseCase
    implements GetExpensesByDateRangeUseCase {
  @override
  Future<Either<Failure, List<Expense>>> execute(
          DateTime startDate, DateTime endDate) async =>
      const Right([]);

  @override
  Future<Either<Failure, List<Expense>>> call(
          DateTime startDate, DateTime endDate) async =>
      const Right([]);
}

class TestExpensesController extends ExpensesController {
  TestExpensesController({
    required super.getAllExpensesUseCase,
    required super.saveExpenseUseCase,
    required super.deleteExpenseUseCase,
    required super.getExpensesByDateRangeUseCase,
  });

  @override
  Future<void> loadExpenses() async {
    // No-op
  }
}

void main() {
  tearDown(() {
    Get.reset();
  });

  testWidgets('App starts smoke test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Initialize controllers with Mocks
    Get.put<ExpensesController>(TestExpensesController(
      getAllExpensesUseCase: MockGetAllExpensesUseCase(),
      saveExpenseUseCase: MockSaveExpenseUseCase(),
      deleteExpenseUseCase: MockDeleteExpenseUseCase(),
      getExpensesByDateRangeUseCase: MockGetExpensesByDateRangeUseCase(),
    ));
    Get.put(DisplayExpensesController());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const GetMaterialApp(
      home: MainScreen(),
    ));

    // Verify that MainScreen is present
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
