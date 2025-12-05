import 'package:get/get.dart';

/// Controller to manage the navigation state across the app
class NavigationController extends GetxController {
  /// Current selected index in the navigation bar
  final _currentIndex = 0.obs;

  /// Getter for current index
  int get currentIndex => _currentIndex.value;

  /// Change the current page
  void changePage(int index) {
    _currentIndex.value = index;
  }

  /// Reset to home page
  void resetToHome() {
    _currentIndex.value = 0;
  }
}
