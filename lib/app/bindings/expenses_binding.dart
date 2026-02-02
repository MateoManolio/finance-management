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
import 'package:wise_wallet/app/controllers/cards_controller.dart';
import 'package:wise_wallet/app/domain/repositories/credit_card_repository.dart';
import 'package:wise_wallet/app/data/repositories/credit_card_repository_impl.dart';
import 'package:wise_wallet/app/domain/usecases/save_card_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_cards_usecase.dart';
import 'package:wise_wallet/app/domain/repositories/subscription_repository.dart';
import 'package:wise_wallet/app/data/repositories/subscription_repository_impl.dart';
import 'package:wise_wallet/app/domain/usecases/save_subscription_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_subscriptions_usecase.dart';
import 'package:wise_wallet/app/controllers/subscriptions_controller.dart';
import 'package:wise_wallet/app/controllers/analysis_controller.dart';
import 'package:wise_wallet/app/controllers/profile_controller.dart';
import 'package:wise_wallet/app/domain/repositories/category_repository.dart';
import 'package:wise_wallet/app/data/repositories/category_repository_impl.dart';
import 'package:wise_wallet/app/domain/repositories/tag_repository.dart';
import 'package:wise_wallet/app/data/repositories/tag_repository_impl.dart';
import 'package:wise_wallet/app/data/services/dio_client.dart';
import 'package:wise_wallet/app/domain/repositories/currency_repository.dart';
import 'package:wise_wallet/app/data/repositories/currency_repository_impl.dart';
import 'package:wise_wallet/app/domain/usecases/get_exchange_rate_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_categories_usecase.dart';
import 'package:wise_wallet/app/domain/usecases/get_tags_usecase.dart';
import 'package:wise_wallet/app/controllers/load_expense_controller.dart';
import 'package:wise_wallet/app/controllers/add_subscription_controller.dart';
import 'package:wise_wallet/app/domain/repositories/bank_discount_repository.dart';
import 'package:wise_wallet/app/data/repositories/bank_discount_repository_impl.dart';
import 'package:wise_wallet/app/controllers/bank_discounts_controller.dart';

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
    // Register DioClient as a permanent dependency
    if (!Get.isRegistered<DioClient>()) {
      Get.put(DioClient(), permanent: true);
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
    Get.lazyPut<CreditCardRepository>(
      () => CreditCardRepositoryImpl(Get.find<AppDB>()),
      fenix: true,
    );
    Get.lazyPut<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(Get.find<AppDB>()),
      fenix: true,
    );
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepositoryImpl(Get.find<AppDB>()),
      fenix: true,
    );
    Get.lazyPut<TagRepository>(
      () => TagRepositoryImpl(Get.find<AppDB>()),
      fenix: true,
    );
    Get.lazyPut<CurrencyRepository>(
      () => CurrencyRepositoryImpl(Get.find<DioClient>()),
      fenix: true,
    );
    Get.lazyPut<BankDiscountRepository>(
      () => BankDiscountRepositoryImpl(Get.find<AppDB>()),
      fenix: true,
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

    Get.lazyPut<SaveCardUseCase>(
      () => SaveCardUseCase(Get.find<CreditCardRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetCardsUseCase>(
      () => GetCardsUseCase(Get.find<CreditCardRepository>()),
      fenix: true,
    );

    Get.lazyPut<SaveSubscriptionUseCase>(
      () => SaveSubscriptionUseCase(Get.find<SubscriptionRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetSubscriptionsUseCase>(
      () => GetSubscriptionsUseCase(Get.find<SubscriptionRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetExchangeRateUseCase>(
      () => GetExchangeRateUseCase(Get.find<CurrencyRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetCategoriesUseCase>(
      () => GetCategoriesUseCase(Get.find<CategoryRepository>()),
      fenix: true,
    );

    Get.lazyPut<GetTagsUseCase>(
      () => GetTagsUseCase(Get.find<TagRepository>()),
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
    // First ensure database and services are initialized
    if (!Get.isRegistered<AppDB>() || !Get.isRegistered<DioClient>()) {
      DatabaseBinding().dependencies();
    }

    // Then ensure repositories are available
    if (!Get.isRegistered<ExpenseRepository>() ||
        !Get.isRegistered<CreditCardRepository>() ||
        !Get.isRegistered<SubscriptionRepository>() ||
        !Get.isRegistered<CurrencyRepository>() ||
        !Get.isRegistered<CategoryRepository>() ||
        !Get.isRegistered<TagRepository>()) {
      RepositoryBinding().dependencies();
    }

    // Then ensure use cases are available
    if (!Get.isRegistered<SaveExpenseUseCase>() ||
        !Get.isRegistered<SaveCardUseCase>() ||
        !Get.isRegistered<SaveSubscriptionUseCase>() ||
        !Get.isRegistered<GetExchangeRateUseCase>() ||
        !Get.isRegistered<GetCategoriesUseCase>() ||
        !Get.isRegistered<GetTagsUseCase>()) {
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

    // Register CardsController
    Get.lazyPut<CardsController>(
      () => CardsController(),
    );

    // Register SubscriptionsController
    Get.lazyPut<SubscriptionsController>(
      () => SubscriptionsController(),
    );

    // Register AnalysisController
    Get.lazyPut<AnalysisController>(
      () => AnalysisController(
        getExpensesByDateRangeUseCase:
            Get.find<GetExpensesByDateRangeUseCase>(),
        getAllExpensesUseCase: Get.find<GetAllExpensesUseCase>(),
      ),
    );

    // Register ProfileController
    Get.put<ProfileController>(
      ProfileController(
        categoryRepository: Get.find<CategoryRepository>(),
        tagRepository: Get.find<TagRepository>(),
        getExchangeRateUseCase: Get.find<GetExchangeRateUseCase>(),
      ),
      permanent: true,
    );

    // Register LoadExpenseController
    Get.lazyPut<LoadExpenseController>(
      () => LoadExpenseController(
        getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
        getTagsUseCase: Get.find<GetTagsUseCase>(),
        getExchangeRateUseCase: Get.find<GetExchangeRateUseCase>(),
      ),
      fenix: true,
    );

    // Register AddSubscriptionController
    Get.lazyPut<AddSubscriptionController>(
      () => AddSubscriptionController(
        getCategoriesUseCase: Get.find<GetCategoriesUseCase>(),
        getTagsUseCase: Get.find<GetTagsUseCase>(),
        getExchangeRateUseCase: Get.find<GetExchangeRateUseCase>(),
      ),
      fenix: true,
    );

    // Register BankDiscountsController
    Get.lazyPut<BankDiscountsController>(
      () => BankDiscountsController(
        repository: Get.find<BankDiscountRepository>(),
      ),
      fenix: true,
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
