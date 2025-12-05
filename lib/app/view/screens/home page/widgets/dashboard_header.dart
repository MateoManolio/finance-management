import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/expenses_controller.dart';
import '../../../widgets/glass_container.dart';

class DashboardHeader extends GetView<ExpensesController> {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Mi Billetera',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saldo Actual: ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                '\$850 USD',
                style: TextStyle(
                  color: Color(0xFF4CAF50), // Green
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Gastos del Mes: ',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '\$${controller.getTotalExpenses().toStringAsFixed(0)} USD',
                    style: const TextStyle(
                      color: Color(0xFFE57373), // Red
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
