import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:wise_wallet/app/controllers/expenses_controller.dart';
import 'package:wise_wallet/app/controllers/display_expenses_controller.dart';
import 'package:wise_wallet/app/core/app_theme.dart';
import 'package:wise_wallet/app/view/screens/main%20page/main_screen.dart';

void main() async {
  // Initialize global controllers
  Get.put(ExpensesController());
  Get.put(DisplayExpensesController());

  runApp(GetMaterialApp(
    theme: AppTheme().appTheme(),
    home: const MainScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
