import 'package:flutter/material.dart';
import 'package:wise_wallet/app/core/app_constants.dart';
import '../models/navigation_item_model.dart';

/// A single navigation item with glossy effect and smooth animations
class GlossyNavigationItem extends StatefulWidget {
  /// The navigation item data
  final NavigationItemModel item;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Callback when the item is tapped
  final VoidCallback onTap;

  /// The primary color from the theme
  final Color primaryColor;

  /// The unselected color for icons and text
  final Color unselectedColor;

  const GlossyNavigationItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.primaryColor,
    required this.unselectedColor,
  });

  @override
  State<GlossyNavigationItem> createState() => _GlossyNavigationItemState();
}

class _GlossyNavigationItemState extends State<GlossyNavigationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.defaultAnimationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final color = widget.isSelected
        ? (isLight
            ? Color.alphaBlend(
                Colors.black.withValues(alpha: 0.2), widget.primaryColor)
            : widget.primaryColor)
        : widget.unselectedColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.smallPadding,
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      widget.item.icon,
                      size: 24,
                      color: color,
                    ),
                  ),
                  if (widget.item.badgeCount != null &&
                      widget.item.badgeCount! > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            widget.item.badgeCount! > 9
                                ? '9+'
                                : widget.item.badgeCount.toString(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onError,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              // Label
              AnimatedDefaultTextStyle(
                duration: AppConstants.defaultAnimationDuration,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight:
                      widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  color: color,
                  letterSpacing: isLight ? 0.3 : 0.5,
                ),
                child: Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
