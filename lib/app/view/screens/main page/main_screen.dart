import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../controllers/navigation_controller.dart';
import '../home page/home.dart';
import '../home page/widgets/animated_blur_bubble.dart';
import '../hub page/hub_screen.dart';
import '../analysis/analysis_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/navigation_bar.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/analysis_controller.dart';
import '../lock/lock_screen.dart';
import '../../../service/auth_service.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:home_widget/home_widget.dart';
import '../load_expense/load_expense_screen.dart';
import '../load_expense/quick_expense_screen.dart';

/// Main screen that wraps all navigation screens with the glossy navigation bar
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late PageController _pageController;
  final NavigationController _navigationController =
      Get.put(NavigationController());

  StreamSubscription? _widgetClickSubscription;

  bool _isNavigatingViaBar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize AnalysisController to trigger a widget update on start
    if (!Get.isRegistered<AnalysisController>()) {
      Get.put(AnalysisController(
        getExpensesByDateRangeUseCase: Get.find(),
        getAllExpensesUseCase: Get.find(),
      ));
    } else {
      Get.find<AnalysisController>().refreshData();
    }

    _pageController =
        PageController(initialPage: _navigationController.currentIndex);
    _initQuickActions();
    _initHomeWidgetListener();
    _checkForWidgetLaunch();
  }

  Future<void> _checkForWidgetLaunch() async {
    final Uri? launchedUri = await HomeWidget.initiallyLaunchedFromHomeWidget();
    if (launchedUri != null) {
      _handleWidgetUri(launchedUri);
    }
  }

  void _initHomeWidgetListener() {
    // Listen for widget clicks when app is already running (warm start)
    _widgetClickSubscription = HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        _handleWidgetUri(uri);
      }
    });
  }

  void _handleWidgetUri(Uri uri) {
    if (uri.host == 'quick_add') {
      _openQuickAdd();
    } else if (uri.host == 'analysis') {
      _onNavigationItemSelected(1); // Index 1 is Analysis
    }
  }

  void _initQuickActions() {
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((shortcutType) {
      // Use a delay to ensure navigator is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        if (shortcutType == 'add_expense') {
          Get.to(() => const LoadExpenseScreen());
        } else if (shortcutType == 'view_analysis') {
          _onNavigationItemSelected(1); // Index 1 is Analysis
        } else if (shortcutType == 'quick_add') {
          _openQuickAdd();
        }
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'add_expense',
        localizedTitle: 'shortcut_add_expense_short'.tr,
        icon: 'ic_shortcut_add',
      ),
      ShortcutItem(
        type: 'view_analysis',
        localizedTitle: 'shortcut_view_analysis_short'.tr,
        icon: 'ic_shortcut_analysis',
      ),
    ]);
  }

  void _openQuickAdd() {
    Get.to(() => const QuickExpenseScreen(), opaque: false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final profileController = Get.find<ProfileController>();
      final authService = Get.find<AuthService>();

      // Only lock if:
      // 1. Passcode is enabled
      // 2. We are NOT already on the LockScreen
      // 3. We are NOT currently in the middle of an authentication prompt
      if (profileController.usePasscode.value &&
          Get.currentRoute != '/LockScreen' &&
          !authService.isAuthenticated.value) {
        Get.to(() => const LockScreen(), routeName: '/LockScreen');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _widgetClickSubscription?.cancel();
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
    final theme = Theme.of(context);
    // Define navigation items
    final navigationItems = [
      NavigationItemModel(
        icon: Icons.home_rounded,
        label: 'nav_home'.tr,
      ),
      NavigationItemModel(
        icon: Icons.analytics_rounded,
        label: 'nav_analysis'.tr,
      ),
      NavigationItemModel(
        icon: Icons.credit_card_rounded,
        label: 'nav_cards'.tr,
      ),
      NavigationItemModel(
        icon: Icons.person_rounded,
        label: 'nav_profile'.tr,
      ),
    ];

    // Define screens for each navigation item
    final List<Widget> screens = [
      const Home(),
      const AnalysisScreen(),
      const HubScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,
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
