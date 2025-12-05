import 'package:flutter/material.dart';

/// A reusable animated blur bubble widget for creating modern background effects.
///
/// Features:
/// - Configurable color, size, and position
/// - Large blur effect for glassmorphism aesthetics
/// - Subtle pulsing animation for modern UI feel
/// - Invisible center with strong blur for diffuse glow effect
class AnimatedBlurBubble extends StatefulWidget {
  /// The color of the bubble (will be applied with opacity)
  final Color color;

  /// The size (width and height) of the bubble
  final double size;

  /// The opacity of the shadow/blur effect (0.0 to 1.0)
  final double opacity;

  /// The opacity of the solid container (usually very low for diffuse effect)
  final double containerOpacity;

  /// The blur radius for the shadow effect
  final double blurRadius;

  /// The spread radius for the shadow effect
  final double spreadRadius;

  /// Duration of the pulsing animation
  final Duration animationDuration;

  /// Scale factor for the pulsing effect (1.0 = no pulse)
  final double pulseScale;

  const AnimatedBlurBubble({
    super.key,
    required this.color,
    this.size = 300,
    this.opacity = 0.4,
    this.containerOpacity =
        0.0, // Completely transparent by default - only blur visible
    this.blurRadius = 200,
    this.spreadRadius = 100,
    this.animationDuration = const Duration(seconds: 4),
    this.pulseScale = 1.1,
  });

  @override
  State<AnimatedBlurBubble> createState() => _AnimatedBlurBubbleState();
}

class _AnimatedBlurBubbleState extends State<AnimatedBlurBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Create scale animation (subtle pulsing)
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pulseScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Create opacity animation (subtle breathing effect)
    _opacityAnimation = Tween<double>(
      begin: widget.opacity * 0.8,
      end: widget.opacity,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation loop
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.color.withValues(alpha: widget.containerOpacity),
              boxShadow: [
                BoxShadow(
                  color:
                      widget.color.withValues(alpha: _opacityAnimation.value),
                  blurRadius: widget.blurRadius,
                  spreadRadius: widget.spreadRadius,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
