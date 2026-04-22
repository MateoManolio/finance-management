import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/expenses_controller.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/display_expenses_controller.dart';
import 'package:wise_wallet/app/domain/entity/credit_card.dart';
import 'package:wise_wallet/app/domain/entity/expense.dart';
import '../../widgets/common_credit_card.dart';
import '../../screens/home page/widgets/expense_widget.dart';
import '../../../controllers/load_expense_controller.dart';
import '../../screens/load_expense/load_expense_screen.dart';

class CardExpensesScreen extends StatelessWidget {
  final CreditCard card;

  const CardExpensesScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is available
    if (!Get.isRegistered<DisplayExpensesController>()) {
      Get.lazyPut(() => DisplayExpensesController());
    }

    final ExpensesController expensesController =
        Get.find<ExpensesController>();

    // Filter expenses for this card
    final filteredExpenses = expensesController.expenses
        .where((e) => e.card?.id == card.id)
        .toList();

    // Calculate total
    final totalSpent =
        filteredExpenses.fold(0.0, (sum, item) => sum + item.value);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient with Fade Animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: ModalRoute.of(context)?.animation ??
                  const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                final opacity = ModalRoute.of(context)?.animation?.value ?? 1.0;
                return Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          card.color.withValues(alpha: 0.3),
                          Colors.black,
                          Colors.black,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'card_detail'.tr,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Card Hero
                Hero(
                  tag: 'card_${card.id}',
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    child: Material(
                      color: Colors.transparent,
                      child: CommonCreditCard(card: card),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Summary Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'total_spent'.tr,
                            style: GoogleFonts.outfit(
                              color: Colors.white60,
                              fontSize: 12,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(() {
                            final profile = Get.find<ProfileController>();
                            return Text(
                              profile.formatValue(totalSpent),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: Text(
                          'transactions_count'.trParams({
                            'count': filteredExpenses.length.toString(),
                          }),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Expenses List
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                      border: Border(
                        top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(30)),
                      child: filteredExpenses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.receipt_long_rounded,
                                      size: 60,
                                      color:
                                          Colors.white.withValues(alpha: 0.2)),
                                  const SizedBox(height: 16),
                                  Text(
                                    'no_movements'.tr,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : _buildExpensesList(filteredExpenses),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesList(List<Expense> expenses) {
    // Group expenses by date
    final grouped = <DateTime, List<Expense>>{};
    for (var expense in expenses) {
      final date =
          DateTime(expense.time.year, expense.time.month, expense.time.day);
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(expense);
    }

    // Sort dates descending
    final sortedDates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dailyExpenses = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 12, top: 8),
              child: Text(
                Get.find<DisplayExpensesController>()
                    .formatDate(date)
                    .toUpperCase(),
                style: GoogleFonts.outfit(
                  color: Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            ...dailyExpenses.map((expense) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ExpenseWidget(
                    expense: expense,
                    onTap: () {
                      final controller = Get.find<LoadExpenseController>();
                      controller.loadExistingExpense(expense);
                      Get.to(() => const LoadExpenseScreen(), opaque: false);
                    },
                  ),
                )),
            if (index < sortedDates.length - 1) const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}
