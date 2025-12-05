/// Navigation Bar Components
///
/// A collection of widgets for creating a modern glassmorphism navigation bar
/// with smooth animations and glossy effects.
///
/// Usage:
/// ```dart
/// import 'package:wallet_wise/app/view/screens/widgets/navigation_bar/navigation_bar.dart';
///
/// GlossyNavigationBar(
///   items: [
///     NavigationItemModel(icon: Icons.home, label: 'Inicio'),
///     NavigationItemModel(icon: Icons.analytics, label: 'Análisis'),
///   ],
///   currentIndex: 0,
///   onItemSelected: (index) => print('Selected: $index'),
/// )
/// ```

export '../models/navigation_item_model.dart';
export 'glossy_navigation_item.dart';
export 'glossy_navigation_bar.dart';
