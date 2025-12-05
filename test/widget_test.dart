import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/controllers/expenses_controller.dart';
import 'package:wise_wallet/app/controllers/display_expenses_controller.dart';
import 'package:wise_wallet/app/view/screens/main page/main_screen.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Initialize controllers
    Get.put(ExpensesController());
    Get.put(DisplayExpensesController());

    // Build our app and trigger a frame.
    await tester.pumpWidget(const GetMaterialApp(
      home: MainScreen(),
    ));

    // Verify that MainScreen is present
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
