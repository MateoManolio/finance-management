import 'package:flutter/material.dart';
import '../../../../core/app_constants.dart';

class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:
          margin ?? const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            // Refined subtle shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Glass Layer
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                  width: 1.0,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.surface.withValues(
                        alpha: theme.brightness == Brightness.light ? 0.6 : 0.12),
                    theme.colorScheme.surface.withValues(
                        alpha: theme.brightness == Brightness.light ? 0.4 : 0.05),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
