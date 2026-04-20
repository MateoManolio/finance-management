import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:patrol/patrol.dart';
import 'package:wise_wallet/app/data/datasource/app_database.dart';
import 'package:wise_wallet/main.dart' as app;
import 'package:wise_wallet/app/service/auth_service.dart';

class MockAuthService extends AuthService {
  int _authAttempts = 0;

  @override
  Future<bool> authenticate() async {
    _authAttempts++;

    if (_authAttempts == 1) {
      return false;
    }

    isAuthenticated.value = true;
    return true;
  }

  @override
  Future<bool> isDeviceSupported() async => true;
}

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

    Get.delete<AuthService>(force: true);
    Get.put<AuthService>(MockAuthService(), permanent: true);
  });

  setUp(() {
    if (Get.isRegistered<AuthService>()) {
      Get.find<AuthService>().isAuthenticated.value = false;
    }
  });

  patrolTest(
    'unlocks the app from lock screen',
    ($) async {
      await $.pumpWidget(const app.App(
          isDarkMode: true,
          usePasscode: true,
          initialLocale: Locale('es', 'AR')));

      await $(Icons.lock_person_rounded).waitUntilVisible();
      expect($(Icons.lock_person_rounded), findsOneWidget);

      expect($('Autenticación requerida'), findsOneWidget);

      await $('Desbloquear').waitUntilVisible();
      await $.pump(const Duration(seconds: 1));
      await $('Desbloquear').tap();

      await $.pump(const Duration(seconds: 1));

      await $(Icons.home_rounded).waitUntilVisible();
      expect($(Icons.home_rounded), findsOneWidget);
    },
  );
}
