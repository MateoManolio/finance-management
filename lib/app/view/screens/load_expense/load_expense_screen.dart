import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/glass_container.dart';
import '../../../controllers/load_expense_controller.dart';
import 'widgets/expense_drag_handle.dart';
import 'widgets/expense_amount_input.dart';
import 'widgets/expense_card_selector.dart';
import 'widgets/expense_category_selector.dart';
import 'widgets/expense_date_selector.dart';
import 'widgets/expense_note_input.dart';
import 'widgets/expense_tags_selector.dart';
import 'widgets/expense_save_button.dart';

class LoadExpenseScreen extends StatelessWidget {
  const LoadExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoadExpenseController>();
    final screenHeight = MediaQuery.of(context).size.height;

    // Request focus on amount field when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        controller.amountFocusNode.requestFocus();
      });
    });

    return GestureDetector(
      // Tap outside the modal to close
      onTap: () => Get.back(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          // Prevent tap on modal from closing the screen
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: screenHeight * controller.modalHeight.value,
                child: const GlassContainer(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  blur: 20,
                  opacity: 0.1,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag Handle - Only this area allows drag
                      ExpenseDragHandle(),
                      SizedBox(height: 20),

                      // Amount Input
                      ExpenseAmountInput(),
                      SizedBox(height: 16),

                      // Scrollable Content - No drag interference
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Selector
                              ExpenseCardSelector(),
                              SizedBox(height: 20),

                              // Category Selector
                              ExpenseCategorySelector(),
                              SizedBox(height: 16),

                              // Date Selector
                              ExpenseDateSelector(),
                              SizedBox(height: 16),

                              // Note Input (Optional)
                              ExpenseNoteInput(),
                              SizedBox(height: 16),

                              // Tags Selector
                              ExpenseTagsSelector(),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // Save Button
                      ExpenseSaveButton(),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
