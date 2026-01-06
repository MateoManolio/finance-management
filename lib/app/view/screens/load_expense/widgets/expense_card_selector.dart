import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../controllers/cards_controller.dart';
import '../../../../controllers/load_expense_controller.dart';
import '../../../../domain/entity/credit_card.dart';

class ExpenseCardSelector extends StatelessWidget {
  final Rx<CreditCard?>? selectedCardOverride;

  const ExpenseCardSelector({super.key, this.selectedCardOverride});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CardsController>()) {
      Get.put(CardsController());
    }
    final cardsController = Get.find<CardsController>();

    // Determine which observable to use
    Rx<CreditCard?> targetSelectedCard;
    if (selectedCardOverride != null) {
      targetSelectedCard = selectedCardOverride!;
    } else {
      // Fallback for LoadExpenseController (Screen 1)
      if (Get.isRegistered<LoadExpenseController>()) {
        targetSelectedCard = Get.find<LoadExpenseController>().selectedCard;
      } else {
        // Fallback safety
        targetSelectedCard = Rx<CreditCard?>(null);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'MÉTODO DE PAGO',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: Obx(() {
            // Combine "Cash" option with regular cards
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cardsController.cards.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Cash Option
                  return GestureDetector(
                    onTap: () => targetSelectedCard.value = null,
                    child: Obx(() {
                      final isSelected = targetSelectedCard.value == null;
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? Colors.green
                                : Colors.white.withValues(alpha: 0.1),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.money,
                              color: isSelected ? Colors.green : Colors.white70,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Efectivo',
                              style: GoogleFonts.outfit(
                                color: isSelected ? Colors.green : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                }

                final card = cardsController.cards[index - 1];
                return GestureDetector(
                  onTap: () => targetSelectedCard.value = card,
                  child: Obx(() {
                    final isSelected = targetSelectedCard.value?.id == card.id;
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            card.color
                                .withValues(alpha: isSelected ? 0.8 : 0.4),
                            card.color
                                .withValues(alpha: isSelected ? 0.6 : 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.1),
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                  card.type == CardType.credit
                                      ? Icons.credit_card
                                      : Icons.credit_score,
                                  color: Colors.white,
                                  size: 18),
                              if (isSelected)
                                const Icon(Icons.check_circle,
                                    color: Colors.white, size: 16),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.type == CardType.credit
                                    ? 'CREDITO'
                                    : 'DEBITO',
                                style: GoogleFonts.outfit(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '•••• ${card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : card.cardNumber}',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
