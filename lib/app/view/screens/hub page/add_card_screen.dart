import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/add_card_controller.dart';
import '../../../domain/entity/credit_card.dart';
import '../../widgets/glass_container.dart';
import 'package:flutter/services.dart';
import '../../../core/app_constants.dart';
import '../../../core/utils/card_number_formatter.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddCardController());
    final theme = Theme.of(context);

    // Common Input Decoration style
    InputDecoration inputDecoration(String hint, {IconData? icon}) {
      return InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          color: Colors.white.withValues(alpha: 0.3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
      );
    }

    Widget label(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.6),
            letterSpacing: 1.2,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black, // Or specific theme background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Nueva Tarjeta',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Preview (Optional, but looks nice)
            Obx(() => Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: controller.cardColor.value,
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        controller.cardColor.value.withValues(alpha: 0.8),
                        controller.cardColor.value.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.cardIssuer.value.isEmpty
                                ? 'CARD'
                                : controller.cardIssuer.value,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Icon(Icons.contactless_rounded,
                              color: Colors.white70),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Obx(() => Text(
                              controller.selectedCardType.value ==
                                      CardType.credit
                                  ? 'CRÉDITO'
                                  : 'DÉBITO',
                              style: GoogleFonts.outfit(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            )),
                      ),
                      // Placeholders for visual feedback
                      Obx(
                        () => Text(
                          controller.cardNumberPreview.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TITULAR',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                              Obx(() => Text(
                                    controller.holderNamePreview.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EXPIRA',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                              Obx(() => Text(
                                    controller.expiryPreview.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 32),

            // Form
            GlassContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  label('Número de Tarjeta'),
                  TextField(
                    controller: controller.cardNumberController,
                    decoration: inputDecoration('0000 0000 0000 0000',
                        icon: Icons.credit_card),
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.outfit(color: Colors.white),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardNumberInputFormatter(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  label('Titular'),
                  TextField(
                    controller: controller.holderNameController,
                    decoration: inputDecoration('NOMBRE APELLIDO',
                        icon: Icons.person_outline),
                    style: GoogleFonts.outfit(color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('Vencimiento'),
                            TextField(
                              controller: controller.expiryDateController,
                              decoration: inputDecoration('MM/AA',
                                  icon: Icons.calendar_today),
                              keyboardType: TextInputType.datetime,
                              style: GoogleFonts.outfit(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('CVV'),
                            TextField(
                              decoration: inputDecoration('123',
                                  icon: Icons.lock_outline),
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              style: GoogleFonts.outfit(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Card Type Selector (Credit / Debit)
                  label('Tipo de Tarjeta'),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.selectedCardType.value =
                                  CardType.credit,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: controller.selectedCardType.value ==
                                          CardType.credit
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: controller.selectedCardType.value ==
                                            CardType.credit
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'DÉBITO',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.selectedCardType.value =
                                  CardType.debit,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: controller.selectedCardType.value ==
                                          CardType.debit
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: controller.selectedCardType.value ==
                                            CardType.debit
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'CRÉDITO',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),

                  // Closing date and Due date
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('Día de Cierre'),
                            TextField(
                              controller: controller.closingDateController,
                              decoration: inputDecoration('Ej: 25',
                                  icon: Icons.event_busy),
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.outfit(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('Día de Pago'),
                            TextField(
                              controller: controller.dueDateController,
                              decoration: inputDecoration('Ej: 5',
                                  icon: Icons.event_available),
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.outfit(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.saveCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Guardar Tarjeta',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
