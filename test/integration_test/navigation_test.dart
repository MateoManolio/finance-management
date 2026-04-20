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
    'navigates through bottom bar screens',
    ($) async {
      await $.pumpWidget(const app.App(
          isDarkMode: true,
          usePasscode: false,
          initialLocale: Locale('es', 'AR')));

      // Ensure we are on Home
      expect($(Icons.home_rounded), findsOneWidget);

      // Navigate to Analysis
      await $(Icons.analytics_rounded).tap();
      await $.pump(const Duration(milliseconds: 500));

      // Navigate to Cards (Hub)
      await $(Icons.credit_card_rounded).tap();
      await $.pump(const Duration(milliseconds: 500));

      // Navigate to Profile
      await $(Icons.person_rounded).tap();
      await $.pump(const Duration(milliseconds: 500));

      // Back to Home
      await $(Icons.home_rounded).tap();
      await $.pump(const Duration(milliseconds: 500));
    },
  );
}
