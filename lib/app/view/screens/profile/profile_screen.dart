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
                      'Mi Perfil',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ).animate().fadeIn().slideX(begin: -0.2),
                    const SizedBox(height: 8),
                    Text(
                      'Gestiona tus preferencias y datos',
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
                title: 'Personalización',
                items: [
                  SettingsItem(
                    icon: Icons.category_rounded,
                    title: 'Categorías',
                    subtitle: 'Gestiona y reordena tus categorías',
                    onTap: () => Get.to(() => const CategoryManagementPage()),
                  ),
                  SettingsItem(
                    icon: Icons.label_rounded,
                    title: 'Etiquetas',
                    subtitle: 'Crea y elimina etiquetas personalizadas',
                    onTap: () => Get.to(() => const TagManagementPage()),
                  ),
                  SettingsItem(
                    icon: Icons.account_balance_rounded,
                    title: 'Descuentos Bancarios',
                    subtitle: 'Configura tus beneficios del día',
                    onTap: () =>
                        Get.to(() => const BankDiscountsConfigScreen()),
                  ),
                ],
              ).animate().fadeIn(delay: 400.ms),
            ),

            // Preferencias section
            SliverToBoxAdapter(
              child: SettingsSection(
                title: 'Preferencias',
                items: [
                  Obx(() => SettingsItem(
                        icon: Icons.payments_rounded,
                        title: 'Moneda',
                        subtitle:
                            'Moneda principal: ${controller.currency.value}',
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
                        title: 'Idioma',
                        subtitle: controller.language.value == 'es_ARG'
                            ? 'Español (Arg)'
                            : 'English',
                        trailing: DropdownButton<String>(
                          value: controller.language.value,
                          underline: const SizedBox(),
                          items: [
                            {'label': 'Español', 'value': 'es_ARG'},
                            {'label': 'English', 'value': 'en_US'},
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
                        title: 'Tema',
                        subtitle: controller.isDarkMode.value
                            ? 'Modo Oscuro'
                            : 'Modo Claro',
                        trailing: Switch(
                          value: controller.isDarkMode.value,
                          onChanged: (_) => controller.toggleTheme(),
                        ),
                      )),
                ],
              ).animate().fadeIn(delay: 500.ms),
            ),

            // Seguridad y Datos section
            SliverToBoxAdapter(
              child: SettingsSection(
                title: 'Avanzado',
                items: [
                  Obx(() => SettingsItem(
                        icon: Icons.lock_rounded,
                        title: 'Código de acceso',
                        subtitle: 'Protege tu aplicación',
                        trailing: Switch(
                          value: controller.usePasscode.value,
                          onChanged: (val) => controller.togglePasscode(val),
                        ),
                      )),
                  SettingsItem(
                    icon: Icons.ios_share_rounded,
                    title: 'Exportar Datos',
                    subtitle: 'Descarga tus transacciones en JSON',
                    onTap: controller.exportData,
                  ),
                  SettingsItem(
                    icon: Icons.delete_forever_rounded,
                    title: 'Borrar Datos',
                    subtitle: 'Elimina toda la información local',
                    titleColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
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
}
