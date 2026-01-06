import 'package:flutter/material.dart';

class TotalSpentCard extends StatelessWidget {
  final double total;
  final bool isAllTime;
  final double allTimeTotal;

  const TotalSpentCard({
    super.key,
    required this.total,
    required this.isAllTime,
    required this.allTimeTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: .3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAllTime ? 'Gasto Histórico' : 'Gasto del Mes',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: .8),
                ),
              ),
              Icon(
                Icons.account_balance_wallet_rounded,
                color: theme.colorScheme.onPrimary.withValues(alpha: .5),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!isAllTime) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total Histórico: \$${allTimeTotal.toStringAsFixed(0)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
