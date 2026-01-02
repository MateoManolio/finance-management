import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entity/credit_card.dart';
import '../../core/utils/card_number_formatter.dart';
import '../../core/utils/card_validator.dart';
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
        color: card.color.withOpacity(0.2),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            card.color.withOpacity(0.6),
            card.color.withOpacity(0.2),
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
                      card.type == CardType.credit ? 'CRÉDITO' : 'DÉBITO',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.contactless_rounded,
                        color: Colors.white70, size: 20),
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
                        'TITULAR',
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.7),
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
                      'EXPIRA',
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.7),
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
