import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wise_wallet/app/core/app_constants.dart';
import 'glossy_navigation_item.dart';
import '../models/navigation_item_model.dart';

/// A modern glassmorphism navigation bar with smooth animations
class GlossyNavigationBar extends StatelessWidget {
  /// List of navigation items to display
  final List<NavigationItemModel> items;

  /// Currently selected index
  final int currentIndex;

  /// Callback when an item is selected
  final ValueChanged<int> onItemSelected;

  /// Optional custom background color
  final Color? backgroundColor;

  /// Optional custom border color
  final Color? borderColor;

  const GlossyNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
    this.backgroundColor,
    this.borderColor,
  }) : assert(
            items.length >= 2, 'Navigation bar should have more than 2 items');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        // Outer glow/shadow
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.largeRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppConstants.glassBlur,
            sigmaY: AppConstants.glassBlur,
          ),
          child: Container(
            height: 80, // Fixed height to prevent expansion
            decoration: BoxDecoration(
              // Glassmorphism gradient background
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  backgroundColor?.withValues(alpha: 0.25) ??
                      colorScheme.surface.withValues(alpha: 0.25),
                  backgroundColor?.withValues(alpha: 0.15) ??
                      colorScheme.surface.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.largeRadius),
              // Border with glossy effect
              border: Border.all(
                color: borderColor?.withValues(alpha: 0.3) ??
                    Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;

                return Stack(
                  children: [
                    // Glossy highlight effect at the top
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0),
                              Colors.white.withValues(alpha: 0.4),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Sliding Indicator (Glow & Background)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: (currentIndex * itemWidth) + (itemWidth / 2) - 20,
                      top: 12,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.15),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Navigation items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        items.length,
                        (index) => SizedBox(
                          width: itemWidth,
                          height: 80,
                          child: GlossyNavigationItem(
                            item: items[index],
                            isSelected: currentIndex == index,
                            onTap: () => onItemSelected(index),
                            primaryColor: colorScheme.primary,
                            unselectedColor:
                                colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
