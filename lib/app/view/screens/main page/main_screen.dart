import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation_controller.dart';
import '../home page/home.dart';
import '../home page/widgets/animated_blur_bubble.dart';
import '../hub page/hub_screen.dart';
import 'widgets/navigation_bar.dart';

/// Main screen that wraps all navigation screens with the glossy navigation bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  final NavigationController _navigationController =
      Get.put(NavigationController());

  bool _isNavigatingViaBar = false;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: _navigationController.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavigationItemSelected(int index) {
    _isNavigatingViaBar = true;
    _navigationController.changePage(index);
    _pageController
        .animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    )
        .then((_) {
      _isNavigatingViaBar = false;
    });
  }

  void _onPageChanged(int index) {
    if (!_isNavigatingViaBar) {
      _navigationController.changePage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define navigation items
    const navigationItems = [
      NavigationItemModel(
        icon: Icons.home_rounded,
        label: 'Inicio',
      ),
      NavigationItemModel(
        icon: Icons.analytics_rounded,
        label: 'Análisis',
      ),
      NavigationItemModel(
        icon: Icons.credit_card_rounded,
        label: 'Tarjetas',
      ),
      NavigationItemModel(
        icon: Icons.person_rounded,
        label: 'Perfil',
      ),
    ];

    // Define screens for each navigation item
    final List<Widget> screens = [
      const Home(),
      const _AnalysisScreen(),
      const HubScreen(),
      const _ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Elements - Animated and Persistent
          Obx(() {
            final index = _navigationController.currentIndex;

            // Define positions for Bubble 1 (Tertiary)
            // Using a simple list of positions for each index
            final bubble1Positions = [
              {'top': -100.0, 'left': -100.0}, // Home
              {'top': -50.0, 'left': 200.0}, // Analysis
              {'top': 400.0, 'left': -100.0}, // Cards
              {'top': 100.0, 'left': 100.0}, // Profile
            ];

            // Define positions for Bubble 2 (Primary)
            final bubble2Positions = [
              {'bottom': 100.0, 'right': -50.0}, // Home
              {'bottom': -50.0, 'right': 200.0}, // Analysis
              {'bottom': 400.0, 'right': -50.0}, // Cards
              {'bottom': 100.0, 'right': 100.0}, // Profile
            ];

            // Get current positions safely (fallback to 0 if index out of bounds)
            final b1Pos = bubble1Positions[index % bubble1Positions.length];
            final b2Pos = bubble2Positions[index % bubble2Positions.length];

            final theme = Theme.of(context);

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                  top: b1Pos['top'],
                  left: b1Pos['left'],
                  child: AnimatedBlurBubble(
                    color: theme.colorScheme.tertiary,
                    size: 300,
                    opacity: 0.5,
                    containerOpacity: 0.0,
                    blurRadius: 300,
                    spreadRadius: 180,
                    animationDuration: const Duration(seconds: 4),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOutCubic,
                  bottom: b2Pos['bottom'],
                  right: b2Pos['right'],
                  child: AnimatedBlurBubble(
                    color: theme.colorScheme.primary,
                    size: 200,
                    opacity: 0.4,
                    containerOpacity: 0.0,
                    blurRadius: 250,
                    spreadRadius: 150,
                    animationDuration: const Duration(seconds: 5),
                    pulseScale: 1.15,
                  ),
                ),
              ],
            );
          }),

          // Content area
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: screens,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => GlossyNavigationBar(
            items: navigationItems,
            currentIndex: _navigationController.currentIndex,
            onItemSelected: _onNavigationItemSelected,
          ),
        ),
      ),
    );
  }
}

/// Placeholder screens for demonstration
/// Replace these with your actual screens

class _AnalysisScreen extends StatelessWidget {
  const _AnalysisScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Análisis',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Visualiza tus gastos y tendencias',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 80,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Perfil',
              style: theme.textTheme.headlineLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Configura tu cuenta y preferencias',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
