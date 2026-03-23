import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/glass_container.dart';
import '../../../controllers/load_expense_controller.dart';
import 'widgets/expense_drag_handle.dart';
import 'widgets/expense_amount_input.dart';
import 'widgets/expense_card_selector.dart';
import 'widgets/expense_category_selector.dart';
import 'widgets/expense_save_button.dart';

class QuickExpenseScreen extends StatefulWidget {
  const QuickExpenseScreen({super.key});

  @override
  State<QuickExpenseScreen> createState() => _QuickExpenseScreenState();
}

class _QuickExpenseScreenState extends State<QuickExpenseScreen> {
  late final LoadExpenseController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LoadExpenseController>();
    // Reset form ONLY once when screen is first created
    controller.resetForm();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted && controller.amountFocusNode.canRequestFocus) {
        controller.amountFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Show Android Home Screen wallpaper!
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => Get.back(), // Close when tapping outside the modal
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black
              .withValues(alpha: 0.15), // Subtle dim over the home screen
          child: Column(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () {}, // Prevent closing when tapping inside the modal
                child: GlassContainer(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  blur: 20,
                  opacity: 0.1,
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: screenHeight * 0.75),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: bottomInset),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ExpenseDragHandle(),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'quick_add'.tr,
                                  style: const TextStyle(
                                    color: Color(0xFF00C9A7),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.close, color: Colors.white70),
                                  onPressed: () => Get.back(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const ExpenseAmountInput(),
                            const SizedBox(height: 16),
                            const ExpenseCardSelector(),
                            const SizedBox(height: 20),
                            const ExpenseCategorySelector(),
                            const SizedBox(height: 16),
                            const SizedBox(height: 10),
                            const ExpenseSaveButton(),
                            const SizedBox(
                                height:
                                    24), // Extra padding for bottom navigation bars
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
