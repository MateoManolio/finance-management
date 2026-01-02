import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../controllers/add_subscription_controller.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/modal_drag_handle.dart';
import '../load_expense/widgets/expense_card_selector.dart';

class AddSubscriptionScreen extends StatelessWidget {
  const AddSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddSubscriptionController());
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    // Helper for inputs
    Widget inputField(String label, TextEditingController ctrl,
        {TextInputType type = TextInputType.text,
        IconData? icon,
        String? placeholder}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.6),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: ctrl,
              keyboardType: type,
              style: GoogleFonts.outfit(
                  color: Colors.white, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: GoogleFonts.outfit(
                    color: Colors.white.withValues(alpha: 0.3)),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                prefixIcon: icon != null
                    ? Icon(icon, color: Colors.white70, size: 20)
                    : null,
              ),
            ),
          ),
        ],
      );
    }

    Widget label(String text) {
      return Text(
        text.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white.withValues(alpha: 0.6),
          letterSpacing: 1.2,
        ),
      );
    }

    return GestureDetector(
      onTap: () => Get.back(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: screenHeight * controller.modalHeight.value,
                child: GlassContainer(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  blur: 20,
                  opacity: 0.1, // Dark modal background feel
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ModalDragHandle(
                        title: 'Nueva Suscripción',
                        onVerticalDragStart: controller.onDragStart,
                        onVerticalDragUpdate: controller.onDragUpdate,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              inputField('Nombre', controller.nameController,
                                  placeholder: 'Netflix, Spotify...',
                                  icon: Icons.subscriptions_outlined),
                              const SizedBox(height: 16),

                              // Card Selector
                              ExpenseCardSelector(
                                selectedCardOverride: controller.selectedCard,
                              ),
                              const SizedBox(height: 16),

                              inputField(
                                  'Precio Base', controller.priceController,
                                  type: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  placeholder: '0.00',
                                  icon: Icons.attach_money),
                              const SizedBox(height: 16),

                              // Category Selector (Simplified UI for now)
                              label('CATEGORÍA'),
                              const SizedBox(height: 8),
                              Obx(() => Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: controller
                                            .selectedCategory.value?.name,
                                        dropdownColor: const Color(0xFF1E1E1E),
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Colors.white70),
                                        isExpanded: true,
                                        hint: Text('Seleccionar Categoría',
                                            style: GoogleFonts.outfit(
                                                color: Colors.white54)),
                                        onChanged: (val) {
                                          final cat = controller
                                              .availableCategories
                                              .firstWhere((c) => c.name == val);
                                          controller.selectedCategory.value =
                                              cat;
                                        },
                                        items: controller.availableCategories
                                            .map((e) => DropdownMenuItem(
                                                value: e.name,
                                                child: Row(
                                                  children: [
                                                    Icon(e.icon,
                                                        color: e.color,
                                                        size: 18),
                                                    const SizedBox(width: 8),
                                                    Text(e.name),
                                                  ],
                                                )))
                                            .toList(),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 16),

                              // Date Selection
                              label('PRÓXIMO PAGO'),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        controller.nextPaymentDate.value,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2030),
                                    builder: (context, child) {
                                      return Theme(
                                        data: ThemeData.dark().copyWith(
                                          colorScheme: ColorScheme.dark(
                                            primary: theme.colorScheme.primary,
                                            onPrimary: Colors.white,
                                            surface: const Color(0xFF1E1E1E),
                                            onSurface: Colors.white,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null)
                                    controller.updateDate(picked);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.white
                                            .withValues(alpha: 0.1)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Obx(() => Text(
                                            DateFormat('EEEE, d MMMM yyyy')
                                                .format(controller
                                                    .nextPaymentDate.value),
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      const Icon(Icons.calendar_today_rounded,
                                          color: Colors.white70, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Renewal Cycle Selector
                              label('CICLO DE RENOVACIÓN'),
                              const SizedBox(height: 8),
                              Obx(() => Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: controller.renewalCycle.value,
                                        dropdownColor: const Color(
                                            0xFF1E1E1E), // Dark background for dropdown
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        icon: const Icon(Icons.arrow_drop_down,
                                            color: Colors.white70),
                                        isExpanded: true,
                                        onChanged: (val) {
                                          if (val != null)
                                            controller.renewalCycle.value = val;
                                        },
                                        items: [
                                          'Mensual',
                                          'Anual',
                                          'Semanal',
                                          'Trimestral'
                                        ]
                                            .map((e) => DropdownMenuItem(
                                                value: e, child: Text(e)))
                                            .toList(),
                                      ),
                                    ),
                                  )),
                              const SizedBox(height: 16),

                              // Auto Pay Checkbox
                              Obx(() => SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    inactiveTrackColor:
                                        Colors.white.withValues(alpha: 0.1),
                                    activeColor: theme.colorScheme.primary,
                                    title: Text('Pago Automático',
                                        style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        'Se descontará automáticamente',
                                        style: GoogleFonts.outfit(
                                            color: Colors.white54,
                                            fontSize: 12)),
                                    value: controller.isAutoPay.value,
                                    onChanged: (val) =>
                                        controller.isAutoPay.value = val,
                                  )),

                              // Impuestos / Extra Fee
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: inputField(
                                      'Impuestos (%)',
                                      controller.taxController,
                                      type:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      placeholder: '0%',
                                      icon: Icons.percent,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Live calculation preview could go here
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        label('TOTAL ESTIMADO'),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 56,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withValues(alpha: 0.05),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Obx(() {
                                            double price = double.tryParse(
                                                    controller.priceController
                                                        .text) ??
                                                0.0;
                                            double tax =
                                                controller.taxPercentage.value;
                                            double total =
                                                price + (price * (tax / 100));
                                            return Text(
                                              '\$${total.toStringAsFixed(2)}',
                                              style: GoogleFonts.outfit(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Tags selection (Mockup for now)
                              label('ETIQUETAS'),
                              const SizedBox(height: 8),
                              Obx(() => Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children:
                                        controller.availableTags.map((tag) {
                                      final isSelected =
                                          controller.selectedTags.contains(tag);
                                      return GestureDetector(
                                        onTap: () => controller.toggleTag(tag),
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? tag.color
                                                    .withValues(alpha: 0.3)
                                                : Colors.white
                                                    .withValues(alpha: 0.05),
                                            border: Border.all(
                                                color: isSelected
                                                    ? tag.color
                                                    : Colors.transparent),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            tag.tag,
                                            style: GoogleFonts.outfit(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white70,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )),

                              const SizedBox(height: 16),

                              inputField('Notas', controller.noteController,
                                  placeholder: 'Opcional...',
                                  icon: Icons.text_snippet_outlined),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: controller.saveSubscription,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Guardar Suscripción',
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
