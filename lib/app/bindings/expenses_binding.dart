import 'package:get/get.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/app/data/repositories/expense_repository_impl.dart';
import 'package:wise_wallet/app/domain/repositories/expense_repository.dart';
import 'package:wise_wallet/app/domain/usecases/save_expense_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_all_expenses_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/delete_expense_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_expenses_by_date_range_usecase.dart';
import 'package:wise_wallet/app/controllers/expenses_controller.dart';
import 'package:wise_wallet/app/controllers/display_expenses_controller.dart';

/// Database Binding
/// This binding is responsible for initializing the database
/// It should be loaded at app startup and kept as a permanent dependency
class DatabaseBinding extends Bindings {
  @override
  void dependencies() {
    // Check if loaded
    if (!Get.isRegistered<AppDB>()) {
      // Initialize database as a singleton (permanent)
      // This will be available throughout the app lifecycle
      Get.putAsync<AppDB>(
        () async => await AppDB.create(),
        permanent: true,
      );
    }
  }
}

/// Repository Binding
/// This binding initializes the repositories
/// It depends on DatabaseBinding being loaded first
class RepositoryBinding extends Bindings {
  @override
  void dependencies() {
    // Register ExpenseRepository implementation
    // Using lazy singleton - will be created when first accessed
    Get.lazyPut<ExpenseRepository>(
      () => ExpenseRepositoryImpl(Get.find<AppDB>()),
      fenix: true, // Will be recreated if removed and accessed again
    );
  }
}

/// Use Cases Binding
/// This binding initializes all use cases
/// It depends on RepositoryBinding being loaded first
class UseCasesBinding extends Bindings {
  @override
  void dependencies() {
    // Register all use cases as lazy singletons
    // They will be created when first accessed

    Get.lazyPut<SaveExpenseUseCase>(
      () => SaveExpenseUseCase(Get.find<ExpenseRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetAllExpensesUseCase>(
      () => GetAllExpensesUseCase(Get.find<ExpenseRepository>()),
      fenix: true,
    );

    Get.lazyPut<DeleteExpenseUseCase>(
      () => DeleteExpenseUseCase(Get.find<ExpenseRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetExpensesByDateRangeUseCase>(
      () => GetExpensesByDateRangeUseCase(Get.find<ExpenseRepository>()),
      fenix: true,
    );
  }
}

/// Expenses Binding
/// This is the main binding for the Expenses feature
/// It loads all necessary dependencies in the correct order
class ExpensesBinding extends Bindings {
  @override
  void dependencies() {
    // First ensure database is initialized
    if (!Get.isRegistered<AppDB>()) {
      DatabaseBinding().dependencies();
    }

    // Then ensure repositories are available
    if (!Get.isRegistered<ExpenseRepository>()) {
      RepositoryBinding().dependencies();
    }

    // Then ensure use cases are available
    if (!Get.isRegistered<SaveExpenseUseCase>()) {
      UseCasesBinding().dependencies();
    }

    // Register the controllers
    Get.lazyPut<ExpensesController>(
      () => ExpensesController(
        saveExpenseUseCase: Get.find<SaveExpenseUseCase>(),
        getAllExpensesUseCase: Get.find<GetAllExpensesUseCase>(),
        deleteExpenseUseCase: Get.find<DeleteExpenseUseCase>(),
        getExpensesByDateRangeUseCase:
            Get.find<GetExpensesByDateRangeUseCase>(),
      ),
    );

    // Register DisplayExpensesController
    Get.lazyPut<DisplayExpensesController>(
      () => DisplayExpensesController(),
    );
  }
}

/// Initial Binding
/// This binding should be used in GetMaterialApp
/// It loads all core dependencies needed at app startup
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Load database and core dependencies at startup
    // ExpensesBinding handles DB, Repo, UseCases checks and Controller registration
    ExpensesBinding().dependencies();
  }
}
