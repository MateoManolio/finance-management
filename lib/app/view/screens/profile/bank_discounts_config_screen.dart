import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../controllers/bank_discounts_controller.dart';
import '../../../domain/entity/bank_discount.dart';
import '../../widgets/glass_container.dart';
import '../../../controllers/profile_controller.dart';
import '../../../domain/entity/category.dart' as entity_category;

class BankDiscountsConfigScreen extends GetView<BankDiscountsController> {
  const BankDiscountsConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('bank_discounts'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.discounts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_rounded,
                      size: 64,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_discounts'.tr,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.discounts.length,
              itemBuilder: (context, index) {
                final discount = controller.discounts[index];
                return _BankDiscountItem(
                  discount: discount,
                  onEdit: (d) => _showAddEditDiscountDialog(context, d),
                );
              },
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDiscountDialog(context),
        label: Text('add_discount'.tr),
        icon: const Icon(Icons.add),
      ).animate().scale(delay: 400.ms),
    );
  }

  void _showAddEditDiscountDialog(BuildContext context,
      [BankDiscount? discount]) {
    final bankNameController = TextEditingController(text: discount?.bankName);
    final discountPercentageController =
        TextEditingController(text: discount?.discountPercentage.toString());
    final paymentMethodController =
        TextEditingController(text: discount?.paymentMethod);
    final maxCashbackController =
        TextEditingController(text: discount?.maxCashback?.toString());
    final installmentsController =
        TextEditingController(text: discount?.installments);
    final merchantNameController =
        TextEditingController(text: discount?.merchantName);
    final noteController = TextEditingController(text: discount?.note);

    final selectedDays = RxList<int>(discount?.daysOfWeek ?? []);
    final selectedColor = Rx<Color>(discount?.bankColor ?? Colors.blue);
    final selectedSpecificDate = Rx<DateTime?>(discount?.specificDate);

    // Find matching category object if exists
    final profileController = Get.find<ProfileController>();
    final selectedCategory = Rx<entity_category.Category?>(
        discount?.category != null
            ? profileController.categories
                .firstWhereOrNull((c) => c.name == discount!.category)
            : null);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                discount == null
                    ? 'add_discount'.tr
                    : 'edit_tag'.tr, // Reuse edit_tag or add edit_discount?
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: bankNameController,
                decoration: InputDecoration(
                  labelText: 'bank_name_label'.tr,
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: discountPercentageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'discount_label'.tr,
                        prefixIcon: const Icon(Icons.percent_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(() => GestureDetector(
                        onTap: () {
                          _showColorPicker(context, selectedColor);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedColor.value,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 2),
                          ),
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 16),
              Text('days_of_week'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: List.generate(7, (index) {
                  final day = index + 1;
                  final dayName = _getDayName(day);
                  return Obx(() {
                    final isSelected = selectedDays.contains(day);
                    return FilterChip(
                      label: Text(dayName),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          selectedDays.add(day);
                        } else {
                          selectedDays.remove(day);
                        }
                        if (selectedDays.isNotEmpty) {
                          selectedSpecificDate.value =
                              null; // Clear specific date if days are selected
                        }
                      },
                    );
                  });
                }),
              ),
              const SizedBox(height: 16),
              Text('specific_date_label'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(selectedSpecificDate.value == null
                        ? 'select_single_date'.tr
                        : '${selectedSpecificDate.value!.day}/${selectedSpecificDate.value!.month}/${selectedSpecificDate.value!.year}'),
                    leading: const Icon(Icons.calendar_today_rounded),
                    trailing: selectedSpecificDate.value != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => selectedSpecificDate.value = null,
                          )
                        : null,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate:
                            selectedSpecificDate.value ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        selectedSpecificDate.value = date;
                        selectedDays
                            .clear(); // Clear selected days if specific date is chosen
                      }
                    },
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: merchantNameController,
                decoration: InputDecoration(
                  labelText: 'merchant_label'.tr,
                  prefixIcon: const Icon(Icons.storefront_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: paymentMethodController,
                decoration: InputDecoration(
                  labelText: 'payment_method_label'.tr,
                  prefixIcon: const Icon(Icons.payment_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: installmentsController,
                decoration: InputDecoration(
                  labelText: 'installments_label'.tr,
                  prefixIcon: const Icon(Icons.credit_card_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxCashbackController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'cashback_limit_label'.tr,
                  prefixIcon: const Icon(Icons.money_off_rounded),
                ),
              ),
              const SizedBox(height: 16),
              Text('category'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Obx(() => SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: profileController.categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = profileController.categories[index];
                        final isSelected =
                            selectedCategory.value?.name == cat.name;
                        return ChoiceChip(
                          label: Text(cat.name),
                          selected: isSelected,
                          onSelected: (val) {
                            selectedCategory.value = val ? cat : null;
                          },
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                          ),
                        );
                      },
                    ),
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'additional_notes_label'.tr,
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (bankNameController.text.isEmpty ||
                        discountPercentageController.text.isEmpty ||
                        (selectedDays.isEmpty &&
                            selectedSpecificDate.value == null)) {
                      Get.snackbar(
                          'error'.tr, 'Por favor completa los campos básicos');
                      return;
                    }

                    final newDiscount = BankDiscount(
                      id: discount?.id ?? 0,
                      bankName: bankNameController.text,
                      discountPercentage:
                          double.tryParse(discountPercentageController.text) ??
                              0,
                      daysOfWeek: selectedDays.toList(),
                      paymentMethod: paymentMethodController.text,
                      bankColor: selectedColor.value,
                      maxCashback: double.tryParse(maxCashbackController.text),
                      installments: installmentsController.text,
                      category: selectedCategory.value?.name,
                      merchantName: merchantNameController.text,
                      specificDate: selectedSpecificDate.value,
                      note: noteController.text,
                    );

                    if (discount == null) {
                      controller.addDiscount(newDiscount);
                    } else {
                      controller.updateDiscount(newDiscount);
                    }
                    Get.back();
                  },
                  child: Text(
                      discount == null ? 'create_label'.tr : 'update_label'.tr),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showColorPicker(BuildContext context, Rx<Color> selectedColor) {
    final colors = [
      Colors.red, Colors.orange, Colors.amber, Colors.green, Colors.teal,
      Colors.blue, Colors.indigo, Colors.purple, Colors.pink, Colors.brown,
      const Color(0xFFE31C1C), // Galicia Red
      const Color(0xFF004A2E), // Provincia Green
      const Color(0xFF0072CE), // Santander Blue
      const Color(0xFF002F6C), // BBVA Dark Blue
      const Color(0xFFFFD700), // Macro Gold
      const Color(0xFF6B4226), // ICBC Brownish
    ];

    Get.dialog(
      AlertDialog(
        title: Text('entity_color'.tr),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                selectedColor.value = color;
                Get.back();
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 2),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'short_monday'.tr;
      case 2:
        return 'short_tuesday'.tr;
      case 3:
        return 'short_wednesday'.tr;
      case 4:
        return 'short_thursday'.tr;
      case 5:
        return 'short_friday'.tr;
      case 6:
        return 'short_saturday'.tr;
      case 7:
        return 'short_sunday'.tr;
      default:
        return '';
    }
  }
}

class _BankDiscountItem extends StatelessWidget {
  final BankDiscount discount;
  final Function(BankDiscount) onEdit;

  const _BankDiscountItem({required this.discount, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<BankDiscountsController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: discount.bankColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discount.bankName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (discount.merchantName != null &&
                          discount.merchantName!.isNotEmpty)
                        Text(
                          discount.merchantName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  onPressed: () => onEdit(discount),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 20, color: Colors.redAccent),
                  onPressed: () => _showDeleteConfirmation(context, controller),
                ),
              ],
            ),
            const Divider(color: Colors.white10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${discount.discountPercentage.toStringAsFixed(0)}% Off',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: discount.bankColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      discount.paymentMethod,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      discount.specificDate != null
                          ? '${discount.specificDate!.day}/${discount.specificDate!.month}'
                          : _getDaysString(discount.daysOfWeek),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (discount.category != null)
                      Text(
                        discount.category!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, BankDiscountsController controller) {
    Get.defaultDialog(
      title: 'delete_discount_title'.tr,
      middleText: 'delete_discount_confirm'.tr,
      textConfirm: 'delete'.tr,
      textCancel: 'cancel'.tr,
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteDiscount(discount.id);
        Get.back();
      },
    );
  }

  String _getDaysString(List<int> days) {
    if (days.length == 7) return 'every_day'.tr;
    final names = [
      'short_monday'.tr,
      'short_tuesday'.tr,
      'short_wednesday'.tr,
      'short_thursday'.tr,
      'short_friday'.tr,
      'short_saturday'.tr,
      'short_sunday'.tr
    ];
    return days.map((d) => names[d - 1]).join(', ');
  }
}
