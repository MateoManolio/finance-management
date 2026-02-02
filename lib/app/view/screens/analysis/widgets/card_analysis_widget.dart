import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:wise_wallet/app/domain/entity/credit_card.dart';
import '../../../../controllers/profile_controller.dart';

class CardAnalysisWidget extends StatelessWidget {
  final Map<CreditCard?, double> cardBreakdown;

  const CardAnalysisWidget({super.key, required this.cardBreakdown});

  @override
  Widget build(BuildContext context) {
    if (cardBreakdown.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            'Gastos por Tarjeta',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          itemCount: cardBreakdown.length,
          itemBuilder: (context, index) {
            final card = cardBreakdown.keys.elementAt(index);
            final amount = cardBreakdown.values.elementAt(index);

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    card == null
                        ? Icons.money_rounded
                        : Icons.credit_card_rounded,
                    color: card?.color ?? theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      card?.holderName ?? 'Efectivo',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Obx(() {
                    final profile = Get.find<ProfileController>();
                    return Text(
                      profile.formatValue(amount),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }),
                ],
              ),
            ).animate().fadeIn(delay: (index * 150).ms).slideX(
                begin: index.isEven ? -0.1 : 0.1, curve: Curves.easeOutQuad);
          },
        ),
      ],
    );
  }
}
