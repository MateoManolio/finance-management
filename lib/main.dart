import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/bindings/expenses_binding.dart';
import 'package:wise_wallet/app/core/app_theme.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/app/view/screens/main%20page/main_screen.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting
  await initializeDateFormatting('es_ES', null);

  // Initialize Database
  final db = await AppDB.create();
  Get.put<AppDB>(db, permanent: true);

  runApp(GetMaterialApp(
    theme: AppTheme().appTheme(),
    home: const MainScreen(),
    debugShowCheckedModeBanner: false,
    initialBinding: InitialBinding(),
  ));
}
