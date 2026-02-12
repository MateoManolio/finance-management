import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../controllers/bank_discounts_controller.dart';
import '../../../../domain/entity/bank_discount.dart';
import '../bank_discount_detail_screen.dart';

class BankDiscountTodayCard extends GetView<BankDiscountsController> {
  const BankDiscountTodayCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final activeDiscounts = controller.activeTodayDiscounts;

      if (activeDiscounts.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'today_benefits'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 20),
                clipBehavior: Clip.none,
                itemCount: activeDiscounts.length,
                itemBuilder: (context, index) {
                  final discount = activeDiscounts[index];
                  return _TodayDiscountCard(discount: discount)
                      .animate()
                      .fadeIn(delay: (index * 100).ms)
                      .slideX(begin: 0.2);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _TodayDiscountCard extends StatelessWidget {
  final BankDiscount discount;

  const _TodayDiscountCard({required this.discount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.to(
        () => BankDiscountDetailScreen(discount: discount),
        transition: Transition.downToUp,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutExpo,
      ),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Shadow container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: discount.bankColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          discount.bankColor.withValues(alpha: 0.95),
                          discount.bankColor.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content overlay
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            discount.bankName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: discount.bankColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.star_rounded,
                            color: Colors.white70, size: 20),
                      ],
                    ),
                    if (discount.merchantName != null &&
                        discount.merchantName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          discount.merchantName!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const Spacer(),
                    Text(
                      '${discount.discountPercentage.toStringAsFixed(0)}% OFF',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      discount.paymentMethod,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (discount.installments != null &&
                        discount.installments!.isNotEmpty)
                      Text(
                        discount.installments!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Decorative element
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.account_balance_rounded,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
