import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class AuthService extends GetxService {
  final LocalAuthentication auth = LocalAuthentication();
  final isAuthenticated = false.obs; // Observable flag to track auth state

  Future<bool> isDeviceSupported() async {
    return await auth.isDeviceSupported();
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await auth.canCheckBiometrics;
    } on LocalAuthException {
      return false;
    }
  }

  /// Returns `true` if authenticated, `false` if cancelled/failed,
  /// throws a descriptive string if the device is not set up.
  Future<bool> authenticate() async {
    // First check if the device has credentials configured
    final supported = await auth.isDeviceSupported();
    if (!supported) {
      Get.snackbar('error'.tr, 'auth_not_available'.tr);
      return false;
    }

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'auth_to_access'.tr,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      isAuthenticated.value = didAuthenticate;
      return didAuthenticate;
    } on LocalAuthException catch (e) {
      isAuthenticated.value = false;
      if (e.code == 'NotAvailable' || e.code == 'noCredentialsSet') {
        // Device doesn't have lock screen credentials set
        Get.snackbar('error'.tr, 'auth_setup_required'.tr);
      }
      return false;
    }
  }
}
