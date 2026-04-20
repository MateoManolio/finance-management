import 'dart:ui';

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
  @override
  Future<bool> authenticate() async {
    isAuthenticated.value = true;
    return true;
  }

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<bool> canCheckBiometrics() async => true;
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
    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(MockAuthService(), permanent: true);
    }
  });

  patrolTest(
    'triggers add expense shortcut from home screen',
    ($) async {
      await $.pumpWidget(const app.App(
          isDarkMode: true,
          usePasscode: false,
          initialLocale: Locale('es', 'AR')));

      await $.native.pressHome();
      
      // Wait for home screen to settle
      await Future.delayed(const Duration(seconds: 2));

      // Get screen size from root view
      final rootResponse = await $.platform.android.getNativeViews(null);
      if (rootResponse.roots.isEmpty) fail('No native views found');
      final root = rootResponse.roots.first;
      final screenWidth = root.visibleBounds.maxX;
      final screenHeight = root.visibleBounds.maxY;

      // Find the Wise Wallet app icon
      final response = await $.platform.android.getNativeViews(
        AndroidSelector(text: 'Wise Wallet'),
      );

      if (response.roots.isNotEmpty) {
        final appIcon = response.roots.first;
        
        // Normalize pixel coordinates to 0-1 range for swipe
        final normalizedX = appIcon.visibleCenter.x / screenWidth;
        final normalizedY = appIcon.visibleCenter.y / screenHeight;

        await $.native.swipe(
          from: Offset(normalizedX, normalizedY),
          to: Offset(normalizedX, normalizedY),
          steps: 100, // Large number of steps to simulate long press
        );
      } else {
        fail('Could not find Wise Wallet app icon on home screen');
      }

      // Tap on the 'Nuevo Gasto' shortcut
      await $.native.tap(Selector(text: 'Nuevo Gasto'));

      await $.pumpAndSettle();

      expect($('0.00'), findsOneWidget);
    },
  );
}
