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
    return Padding(
      padding:
          margin ?? const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            // Hollow Shadow Layer
            Positioned.fill(
              child: ClipPath(
                clipper: _HollowShadowClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppConstants.largeRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: AppConstants.shadowOpacity),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Glass Layer
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.largeRadius),
                border: Border.all(
                  color: Colors.white
                      .withValues(alpha: AppConstants.borderOpacity),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(
                        alpha: AppConstants.liquidGlassOpacityStart),
                    Colors.white
                        .withValues(alpha: AppConstants.liquidGlassOpacityEnd),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              padding: padding ??
                  const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding + 4,
                    vertical: 10,
                  ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _HollowShadowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(
        Rect.fromLTWH(-100, -100, size.width + 200, size.height + 200));
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(AppConstants.largeRadius),
    ));
    path.fillType = PathFillType.evenOdd;
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
