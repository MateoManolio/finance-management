import 'package:flutter/material.dart';
import '../../../../core/app_constants.dart';

class BigButton extends StatefulWidget {
  final double value;
  final VoidCallback onTap;
  final IconData leadingIcon;

  const BigButton({
    super.key,
    required this.value,
    required this.onTap,
    required this.leadingIcon,
  });

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton>
    with SingleTickerProviderStateMixin {
  static const double _glowSize = 120.0;
  static const double _buttonSize = 100.0;
  static const double _iconSize = 50.0;
  static const double _scaleFrom = 1.0;
  static const double _scaleTo = 1.1;
  static const double _glowOpacity = 0.2;
  static const double _shadowOpacity = 0.4;
  static const double _blurRadius = 30.0;
  static const double _shadowBlurRadius = 20.0;
  static const double _shadowSpreadRadius = 5.0;
  static const Offset _shadowOffset = Offset(0, 10);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppConstants.pulseAnimationDuration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: _scaleFrom, end: _scaleTo).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing Glow
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: _glowSize,
                  height: _glowSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.tertiary
                        .withValues(alpha: _glowOpacity),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiaryContainer
                            .withValues(alpha: _shadowOpacity),
                        blurRadius: _blurRadius,
                        spreadRadius: _shadowSpreadRadius,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Main Button
          Container(
            width: _buttonSize,
            height: _buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.tertiary,
                  theme.colorScheme.tertiaryContainer,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  blurRadius: _shadowBlurRadius,
                  offset: _shadowOffset,
                ),
              ],
            ),
            child: Icon(
              widget.leadingIcon,
              size: _iconSize,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
