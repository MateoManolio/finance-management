import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Map<String, List<IconData>> iconCategories = {
      'Finanzas': [
        Icons.account_balance_rounded,
        Icons.account_balance_wallet_rounded,
        Icons.payments_rounded,
        Icons.credit_card_rounded,
        Icons.savings_rounded,
        Icons.monetization_on_rounded,
        Icons.trending_up_rounded,
        Icons.trending_down_rounded,
        Icons.receipt_long_rounded,
        Icons.attach_money_rounded,
        Icons.euro_rounded,
        Icons.currency_bitcoin_rounded,
      ],
      'Comida': [
        Icons.restaurant_rounded,
        Icons.fastfood_rounded,
        Icons.local_cafe_rounded,
        Icons.local_bar_rounded,
        Icons.local_pizza_rounded,
        Icons.cake_rounded,
        Icons.icecream_rounded,
        Icons.shopping_cart_rounded,
        Icons.bakery_dining_rounded,
      ],
      'Transporte': [
        Icons.directions_car_rounded,
        Icons.directions_bus_rounded,
        Icons.train_rounded,
        Icons.flight_rounded,
        Icons.directions_bike_rounded,
        Icons.local_taxi_rounded,
        Icons.commute_rounded,
        Icons.ev_station_rounded,
      ],
      'Hogar y Utilidades': [
        Icons.home_rounded,
        Icons.lightbulb_rounded,
        Icons.water_drop_rounded,
        Icons.bolt_rounded,
        Icons.wifi_rounded,
        Icons.phone_iphone_rounded,
        Icons.tv_rounded,
        Icons.cleaning_services_rounded,
      ],
      'Entretenimiento': [
        Icons.movie_rounded,
        Icons.games_rounded,
        Icons.music_note_rounded,
        Icons.sports_soccer_rounded,
        Icons.theater_comedy_rounded,
        Icons.brush_rounded,
        Icons.camera_alt_rounded,
        Icons.local_activity_rounded,
      ],
      'Salud y Cuidado': [
        Icons.medical_services_rounded,
        Icons.medication_rounded,
        Icons.fitness_center_rounded,
        Icons.spa_rounded,
        Icons.self_improvement_rounded,
        Icons.pets_rounded,
      ],
      'Compras': [
        Icons.shopping_bag_rounded,
        Icons.checkroom_rounded,
        Icons.storefront_rounded,
        Icons.redeem_rounded,
        Icons.laptop_chromebook_rounded,
      ],
    };

    return AlertDialog(
      title: const Text('Seleccionar Icono'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView(
          shrinkWrap: true,
          children: iconCategories.entries.map((category) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    category.key,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: category.value.length,
                  itemBuilder: (context, index) {
                    final icon = category.value[index];
                    return GestureDetector(
                      onTap: () => Get.back(result: icon),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 24),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
