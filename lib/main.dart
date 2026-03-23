import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wise_wallet/app/bindings/expenses_binding.dart';
import 'package:wise_wallet/app/core/app_theme.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/app/translations/messages.dart';
import 'package:wise_wallet/app/view/screens/main%20page/main_screen.dart';
import 'package:wise_wallet/app/view/screens/lock/lock_screen.dart';
import 'package:wise_wallet/app/view/screens/load_expense/quick_expense_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting
  await initializeDateFormatting('es_ES', null);

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Database
  final db = await AppDB.create();
  Get.put<AppDB>(db, permanent: true);

  final storage = GetStorage();
  final String savedLanguage = storage.read('language') ?? 'es_ARG';
  final List<String> langParts = savedLanguage.split('_');
  final Locale initialLocale =
      Locale(langParts[0], langParts.length > 1 ? langParts[1] : null);

  final bool isDarkMode = storage.read('isDarkMode') ?? true;
  final bool usePasscode = storage.read('usePasscode') ?? false;

  runApp(GetMaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    translations: Messages(),
    home: usePasscode ? const LockScreen() : const MainScreen(),
    debugShowCheckedModeBanner: false,
    initialBinding: InitialBinding(),
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('es', 'AR'),
      Locale('en', 'US'),
    ],
    locale: initialLocale,
    fallbackLocale: const Locale('es', 'AR'),
    getPages: [
      GetPage(
          name: '/',
          page: () => usePasscode ? const LockScreen() : const MainScreen()),
      GetPage(name: '/quick-add', page: () => const QuickExpenseScreen()),
    ],
  ));
}
