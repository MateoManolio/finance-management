import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entity/credit_card.dart';
import '../../core/utils/card_number_formatter.dart';
import '../../core/utils/card_validator.dart';
import '../../controllers/bank_discounts_controller.dart';
import 'glass_container.dart';

class CommonCreditCard extends StatelessWidget {
  final CreditCard card;

  const CommonCreditCard({
    super.key,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final type = CardValidator.getCardType(card.cardNumber) ?? 'CARD';

    return AspectRatio(
      aspectRatio: 1.586,
      child: GlassContainer(
        padding: const EdgeInsets.all(24),
        color: card.color.withValues(alpha: 0.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            card.color.withValues(alpha: 0.6),
            card.color.withValues(alpha: 0.2),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  type,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      card.type == CardType.credit ? 'credit'.tr : 'debit'.tr,
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.contactless_rounded,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    _DiscountBadge(bankName: card.bankName),
                  ],
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                CardNumberInputFormatter.format(card.cardNumber),
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'card_holder'.tr,
                        style: GoogleFonts.outfit(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        card.holderName.toUpperCase(),
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'card_expires'.tr,
                      style: GoogleFonts.outfit(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      card.expiryDate,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final String? bankName;

  const _DiscountBadge({this.bankName});

  @override
  Widget build(BuildContext context) {
    if (bankName == null || bankName!.isEmpty) return const SizedBox.shrink();

    return GetX<BankDiscountsController>(
      builder: (controller) {
        final activeDiscount = controller.activeTodayDiscounts.firstWhereOrNull(
          (d) => d.bankName.toLowerCase() == bankName!.toLowerCase(),
        );

        if (activeDiscount == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Colors.amber.shade700, size: 14),
              const SizedBox(width: 4),
              Text(
                '${activeDiscount.discountPercentage.toStringAsFixed(0)}%',
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
