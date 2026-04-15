import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/add_subscription_controller.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/modal_drag_handle.dart';
import '../load_expense/widgets/expense_card_selector.dart';
import 'package:wise_wallet/app/core/app_constants.dart';

class AddSubscriptionScreen extends StatelessWidget {
  const AddSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddSubscriptionController>();
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
              border: Border.all(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: TextField(
              controller: ctrl,
              keyboardType: type,
              style: GoogleFonts.outfit(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: GoogleFonts.outfit(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    fontWeight: FontWeight.normal),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                prefixIcon: icon != null
                    ? Icon(icon,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        size: 22)
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
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.largeRadius)),
                  blur: AppConstants.glassBlur,
                  opacity: 0.1, // Dark modal background feel
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ModalDragHandle(
                        title: 'new_subscription'.tr,
                        onVerticalDragStart: controller.onDragStart,
                        onVerticalDragUpdate: controller.onDragUpdate,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              inputField('name'.tr, controller.nameController,
                                  placeholder: 'name_placeholder'.tr,
                                  icon: Icons.subscriptions_outlined),
                              const SizedBox(height: 16),

                              // Card Selector
                              ExpenseCardSelector(
                                selectedCardOverride: controller.selectedCard,
                              ),
                              const SizedBox(height: 16),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  label('base_price'.tr),
                                  Obx(() => GestureDetector(
                                        onTap: controller.toggleCurrency,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: theme.colorScheme.primary
                                                    .withValues(alpha: 0.3)),
                                          ),
                                          child: Text(
                                            controller.selectedCurrency.value,
                                            style: GoogleFonts.outfit(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.defaultRadius),
                                  border: Border.all(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.08),
                                    width: 1,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller.priceController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  style: GoogleFonts.outfit(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.bold),
                                  onChanged: (_) => controller.update(),
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    hintStyle: GoogleFonts.outfit(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.2)),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 16),
                                    prefixIcon: Icon(Icons.attach_money,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                        size: 22),
                                  ),
                                ),
                              ),
                              // Conversion Preview for Subscription
                              Obx(() {
                                if (controller.selectedCurrency.value ==
                                    'ARS') {
                                  return const SizedBox.shrink();
                                }
                                if (controller.isFetchingRate.value) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, left: 16),
                                    child: SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5))),
                                  );
                                }
                                final price =
                                    double.tryParse(controller.price.value) ??
                                        0.0;
                                final converted =
                                    price * controller.exchangeRate.value;
                                return Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, left: 16),
                                  child: Text(
                                    '≈ ARS ${converted.toStringAsFixed(2)}',
                                    style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7)),
                                  ),
                                );
                              }),
                              const SizedBox(height: 16),

                              // Category Selector
                              label('category'.tr.toUpperCase()),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 85,
                                child: Obx(() => ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          controller.availableCategories.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        final category = controller
                                            .availableCategories[index];
                                        final isSelected = controller
                                                .selectedCategory.value?.id ==
                                            category.id;
                                        return GestureDetector(
                                          onTap: () => controller
                                              .selectedCategory
                                              .value = category,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            width: 75,
                                            margin: const EdgeInsets.only(
                                                right: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? category.color?.withValues(
                                                          alpha: 0.2) ??
                                                      theme.colorScheme.primary
                                                          .withValues(
                                                              alpha: 0.2)
                                                  : theme.colorScheme.onSurface
                                                      .withValues(alpha: 0.05),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .defaultRadius),
                                              border: Border.all(
                                                color: isSelected
                                                    ? category.color ??
                                                        Colors.blue
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  category.icon,
                                                  color: isSelected
                                                      ? category.color ??
                                                          theme.colorScheme
                                                              .primary
                                                      : theme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.4),
                                                  size: 24,
                                                ),
                                                const SizedBox(height: 6),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 4),
                                                  child: Text(
                                                    category.name,
                                                    style: GoogleFonts.outfit(
                                                      color: isSelected
                                                          ? theme.colorScheme
                                                              .onSurface
                                                          : theme.colorScheme
                                                              .onSurface
                                                              .withValues(
                                                                  alpha: 0.5),
                                                      fontSize: 10,
                                                      fontWeight: isSelected
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                              ),
                              const SizedBox(height: 16),

                              // Date Selection
                              label('next_payment'.tr.toUpperCase()),
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
                                            onPrimary:
                                                theme.colorScheme.onPrimary,
                                            surface: const Color(0xFF1E1E1E),
                                            onSurface: Colors.white,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (picked != null) {
                                    controller.updateDate(picked);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.03),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.defaultRadius),
                                    border: Border.all(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.08)),
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
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          )),
                                      Icon(Icons.calendar_today_rounded,
                                          color: Colors.white
                                              .withValues(alpha: 0.4),
                                          size: 20),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Renewal Cycle Selector
                              label('renewal_cycle'.tr.toUpperCase()),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 45,
                                child: Obx(() => ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        'monthly',
                                        'yearly',
                                        'weekly',
                                        'quarterly'
                                      ].map((key) {
                                        final isSelected =
                                            controller.renewalCycle.value ==
                                                key;
                                        return GestureDetector(
                                          onTap: () => controller
                                              .renewalCycle.value = key,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? theme.colorScheme.primary
                                                      .withValues(alpha: 0.2)
                                                  : theme.colorScheme.onSurface
                                                      .withValues(alpha: 0.05),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      AppConstants
                                                          .extraSmallRadius),
                                              border: Border.all(
                                                color: isSelected
                                                    ? theme.colorScheme.primary
                                                    : theme
                                                        .colorScheme.onSurface
                                                        .withValues(alpha: 0.1),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                key.tr,
                                                style: GoogleFonts.outfit(
                                                  color: isSelected
                                                      ? theme
                                                          .colorScheme.onSurface
                                                      : theme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                              alpha: 0.5),
                                                  fontWeight: isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )),
                              ),
                              const SizedBox(height: 16),

                              // Auto Pay Checkbox
                              Obx(() => SwitchListTile(
                                    contentPadding: EdgeInsets.zero,
                                    inactiveTrackColor:
                                        Colors.white.withValues(alpha: 0.1),
                                    activeThumbColor: theme.colorScheme.primary,
                                    title: Text('auto_pay'.tr,
                                        style: GoogleFonts.outfit(
                                            color: theme.colorScheme.onSurface,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text('auto_pay_desc'.tr,
                                        style: GoogleFonts.outfit(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5),
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
                                      'taxes'.tr,
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
                                        label('estimated_total'.tr),
                                        const SizedBox(height: 10),
                                        Container(
                                          height: 56,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.05),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.defaultRadius),
                                            border: Border.all(
                                              color: theme.colorScheme.primary
                                                  .withValues(alpha: 0.2),
                                              width: 1,
                                            ),
                                          ),
                                          child: Obx(() {
                                            double priceValue = double.tryParse(
                                                    controller.price.value) ??
                                                0.0;
                                            double tax =
                                                controller.taxPercentage.value;
                                            double total = priceValue +
                                                (priceValue * (tax / 100));
                                            final profile =
                                                Get.find<ProfileController>();
                                            return Text(
                                              profile.formatValue(total),
                                              style: GoogleFonts.outfit(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                letterSpacing: -0.5,
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
                              label('tags_label'.tr.toUpperCase()),
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
                                                : theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.05),
                                            border: Border.all(
                                                color: isSelected
                                                    ? tag.color
                                                    : Colors.transparent),
                                            borderRadius: BorderRadius.circular(
                                                AppConstants.defaultRadius),
                                          ),
                                          child: Text(
                                            tag.tag,
                                            style: GoogleFonts.outfit(
                                              color: isSelected
                                                  ? theme.colorScheme.onSurface
                                                  : theme.colorScheme.onSurface
                                                      .withValues(alpha: 0.6),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  )),

                              const SizedBox(height: 16),

                              inputField('notes'.tr, controller.noteController,
                                  placeholder: 'notes_placeholder'.tr,
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
                              borderRadius: BorderRadius.circular(
                                  AppConstants.defaultRadius),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'save_subscription'.tr,
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
