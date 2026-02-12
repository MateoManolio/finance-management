import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../domain/entity/bank_discount.dart';
import '../../widgets/glass_container.dart';
import '../../../controllers/profile_controller.dart';

class BankDiscountDetailScreen extends StatelessWidget {
  final BankDiscount discount;

  const BankDiscountDetailScreen({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileController = Get.find<ProfileController>();

    double? maxSpend;
    if (discount.maxCashback != null && discount.discountPercentage > 0) {
      maxSpend = discount.maxCashback! / (discount.discountPercentage / 100);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: discount.bankColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                discount.bankName,
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      discount.bankColor,
                      discount.bankColor.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance_rounded,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Merchant Name
                  if (discount.merchantName != null &&
                      discount.merchantName!.isNotEmpty) ...[
                    Text(
                      discount.merchantName!,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2),
                    const SizedBox(height: 8),
                  ],

                  // Category & Days
                  Row(
                    children: [
                      if (discount.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            discount.category!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        discount.specificDate != null
                            ? '${'only_on'.tr} ${discount.specificDate!.day}/${discount.specificDate!.month}'
                            : _getDaysString(discount.daysOfWeek),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                  const SizedBox(height: 32),

                  // Main Info Cards
                  Row(
                    children: [
                      _buildInfoCard(
                        context,
                        'discount'.tr,
                        '${discount.discountPercentage.toStringAsFixed(0)}%',
                        Icons.percent_rounded,
                      ),
                      const SizedBox(width: 16),
                      _buildInfoCard(
                        context,
                        'payment'.tr,
                        discount.paymentMethod,
                        Icons.payment_rounded,
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).scale(),

                  const SizedBox(height: 16),

                  if (discount.maxCashback != null)
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.money_off_rounded,
                                  color: theme.colorScheme.primary),
                              const SizedBox(width: 12),
                              Text(
                                'cashback_limit'.tr,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            profileController
                                .formatValue(discount.maxCashback!),
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const Divider(height: 32, color: Colors.white10),
                          Row(
                            children: [
                              const Icon(Icons.calculate_outlined,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'optimized_spend'.tr,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              Text(
                                profileController.formatValue(maxSpend!),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'optimized_spend_desc'.trParams({
                              'maxSpend':
                                  profileController.formatValue(maxSpend),
                              'maxCashback': profileController
                                  .formatValue(discount.maxCashback!),
                            }),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),

                  const SizedBox(height: 24),

                  if (discount.installments != null &&
                      discount.installments!.isNotEmpty)
                    _buildDetailRow(context, Icons.credit_card_rounded,
                            'financing'.tr, discount.installments!)
                        .animate()
                        .fadeIn(delay: 400.ms),

                  if (discount.note != null && discount.note!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notes_rounded,
                                  color: Colors.white70, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'notes'.tr,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            discount.note!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                  ],

                  const SizedBox(height: 80), // Bottom space
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
      BuildContext context, String label, String value, IconData icon) {
    return Expanded(
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  String _getDaysString(List<int> days) {
    if (days.length == 7) return 'every_day'.tr;
    final names = [
      'monday'.tr,
      'tuesday'.tr,
      'wednesday'.tr,
      'thursday'.tr,
      'friday'.tr,
      'saturday'.tr,
      'sunday'.tr
    ];
    return days.map((d) => names[d - 1]).join(', ');
  }
}
