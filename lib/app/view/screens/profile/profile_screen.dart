import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wise_wallet/app/controllers/profile_controller.dart';
import 'widgets/settings_section.dart';
import 'widgets/category_management.dart';
import 'widgets/tag_management.dart';
import 'bank_discounts_config_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'profile'.tr,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 8),
                    Text(
                      'manage_preferences'.tr,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                  ],
                ),
              ),
            ),

            // Personalización section
            SliverToBoxAdapter(
              child: SettingsSection(
                title: 'customization'.tr,
                items: [
                  SettingsItem(
                    icon: Icons.category_rounded,
                    title: 'categories'.tr,
                    subtitle: 'manage_categories'.tr,
                    onTap: () => Get.to(() => const CategoryManagementPage()),
                  ),
                  SettingsItem(
                    icon: Icons.label_rounded,
                    title: 'tags'.tr,
                    subtitle: 'manage_tags'.tr,
                    onTap: () => Get.to(() => const TagManagementPage()),
                  ),
                  SettingsItem(
                    icon: Icons.account_balance_rounded,
                    title: 'bank_discounts'.tr,
                    subtitle: 'setup_benefits'.tr,
                    onTap: () =>
                        Get.to(() => const BankDiscountsConfigScreen()),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
            ),

            // Preferencias section
            SliverToBoxAdapter(
              child: SettingsSection(
                title: 'preferences'.tr,
                items: [
                  Obx(() => SettingsItem(
                        icon: Icons.payments_rounded,
                        title: 'currency'.tr,
                        subtitle: 'main_currency'
                            .trParams({'currency': controller.currency.value}),
                        trailing: DropdownButton<String>(
                          value: controller.currency.value,
                          underline: const SizedBox(),
                          items:
                              ['USD', 'ARS', 'BTC', 'ETH'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) controller.changeCurrency(val);
                          },
                        ),
                      )),
                  Obx(() => SettingsItem(
                        icon: Icons.language_rounded,
                        title: 'language'.tr,
                        subtitle: controller.language.value == 'es_ARG'
                            ? 'spanish'.tr
                            : 'english'.tr,
                        trailing: DropdownButton<String>(
                          value: controller.language.value,
                          underline: const SizedBox(),
                          items: [
                            {'label': 'spanish'.tr, 'value': 'es_ARG'},
                            {'label': 'english'.tr, 'value': 'en_US'},
                          ].map((Map<String, String> item) {
                            return DropdownMenuItem<String>(
                              value: item['value'],
                              child: Text(item['label']!),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) controller.changeLanguage(val);
                          },
                        ),
                      )),
                  Obx(() => SettingsItem(
                        icon: controller.isDarkMode.value
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        title: 'theme'.tr,
                        subtitle: controller.isDarkMode.value
                            ? 'dark_mode'.tr
                            : 'light_mode'.tr,
                        trailing: Switch(
                          value: controller.isDarkMode.value,
                          onChanged: (_) => controller.toggleTheme(),
                        ),
                      )),
                  Obx(() => SettingsItem(
                        icon: Icons.account_balance_wallet_rounded,
                        title: 'monthly_income'.tr,
                        subtitle:
                            '${'monthly_income_desc'.tr}: ${controller.formatValue(controller.monthlyIncome.value)}',
                        onTap: () {
                          _showIncomeDialog(context, controller);
                        },
                      )),
                ],
              ).animate().fadeIn(delay: 500.ms),
            ),

            // Seguridad y Datos section
            SliverToBoxAdapter(
              child: SettingsSection(
                title: 'advanced'.tr,
                items: [
                  Obx(() => SettingsItem(
                        icon: Icons.lock_rounded,
                        title: 'passcode'.tr,
                        subtitle: 'protect_app'.tr,
                        trailing: Switch(
                          value: controller.usePasscode.value,
                          onChanged: (val) => controller.togglePasscode(val),
                        ),
                      )),
                  SettingsItem(
                    icon: Icons.ios_share_rounded,
                    title: 'export_data'.tr,
                    subtitle: 'download_json'.tr,
                    onTap: controller.exportData,
                  ),
                  SettingsItem(
                    icon: Icons.delete_forever_rounded,
                    title: 'clear_all'.tr,
                    subtitle: 'delete_local'.tr,
                    titleColor: theme.colorScheme.error,
                    iconColor: theme.colorScheme.error,
                    onTap: controller.clearData,
                  ),
                ],
              ).animate().fadeIn(delay: 600.ms),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  void _showIncomeDialog(BuildContext context, ProfileController controller) {
    final theme = Theme.of(context);
    final textController =
        TextEditingController(text: controller.monthlyIncome.value.toString());
    Get.dialog(
      AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('monthly_income'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            )),
        content: TextField(
          controller: textController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: Text('cancel'.tr,
                  style: TextStyle(color: theme.colorScheme.onSurface))),
          TextButton(
            onPressed: () {
              final val = double.tryParse(textController.text) ?? 0.0;
              controller.setMonthlyIncome(val);
              Get.back();
            },
            child: Text('save'.tr,
                style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
