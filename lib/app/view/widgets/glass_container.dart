import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_constants.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? blur;
  final double? opacity;
  final Color? color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur,
    this.opacity,
    this.color,
    this.borderRadius,
    this.padding,
    this.margin,
    this.gradient,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBlur = blur ?? AppConstants.defaultBlur;
    final effectiveOpacity = opacity ?? AppConstants.defaultGlassOpacity;
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(AppConstants.defaultRadius);
    final effectiveColor = color ??
        (Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.onSurface);

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter:
              ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: effectiveOpacity),
              borderRadius: effectiveBorderRadius,
              border: border ??
                  Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: AppConstants.borderOpacity * 0.67),
                    width: 1.5,
                  ),
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      effectiveColor.withValues(alpha: effectiveOpacity + 0.1),
                      effectiveColor.withValues(alpha: effectiveOpacity),
                    ],
                  ),
              boxShadow: boxShadow,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
