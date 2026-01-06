import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../core/app_constants.dart';
import '../../widgets/glass_container.dart';
import '../../../controllers/cards_controller.dart';
import '../../../controllers/subscriptions_controller.dart';
import 'add_card_screen.dart';
import 'add_subscription_screen.dart';
import 'card_expenses_screen.dart';
import '../../widgets/common_credit_card.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Hub',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Cards Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mis Tarjetas',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(
                        () => const AddCardScreen(),
                        transition: Transition.downToUp,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutExpo,
                      );
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              SizedBox(
                height: 200,
                child: GetX<CardsController>(
                  init: Get.isRegistered<CardsController>()
                      ? null
                      : CardsController(),
                  builder: (controller) {
                    if (controller.cards.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay tarjetas guardadas',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      itemCount: controller.cards.length,
                      itemBuilder: (context, index) {
                        final card = controller.cards[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: AppConstants.defaultPadding),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => CardExpensesScreen(card: card),
                                transition: Transition.downToUp,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOutExpo,
                              );
                            },
                            child: Hero(
                              tag: 'card_${card.id}',
                              child: Material(
                                color: Colors.transparent,
                                child: SizedBox(
                                  width: 320,
                                  child: CommonCreditCard(card: card),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: AppConstants.largePadding),

              // Subscriptions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suscripciones',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(
                        () => const AddSubscriptionScreen(),
                        opaque: false,
                        transition: Transition.downToUp,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutExpo,
                      );
                    },
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              GetX<SubscriptionsController>(
                init: Get.isRegistered<SubscriptionsController>()
                    ? null
                    : SubscriptionsController(),
                builder: (controller) {
                  if (controller.subscriptions.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No hay suscripciones activas',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.subscriptions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppConstants.smallPadding),
                    itemBuilder: (context, index) {
                      final sub = controller.subscriptions[index];
                      return _buildSubscriptionItem(
                        context,
                        name: sub.name,
                        price: '\$${sub.totalValue.toStringAsFixed(2)}',
                        cycle: sub.cycle,
                        icon: sub.category.icon,
                        color: sub.color,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionItem(
    BuildContext context, {
    required String name,
    required String price,
    required String cycle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  cycle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
