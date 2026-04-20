import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:patrol/patrol.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/main.dart' as app;

void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
}

void main() {
  setUpAll(() async {
    setupFirebaseMocks();
    await Firebase.initializeApp();
    final testDb = await AppDB.create(isTest: true);
    Get.put<AppDB>(testDb, permanent: true);
  });

  patrolTest(
    'adds a new expense',
    ($) async {
      await $.pumpWidget(const app.App(
          isDarkMode: true,
          usePasscode: false,
          initialLocale: Locale('es', 'AR')));

      await $(Icons.add).tap();

      await $(TextField).enterText('250.50');

      await $('Guardar Transacción').tap();
      expect($(Icons.fastfood_rounded), findsOneWidget);
    },
  );
}
