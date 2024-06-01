import 'dart:math';

import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final double value;
  final Function() onTap;
  final IconData leadingIcon;

  const BigButton({
    super.key,
    required this.value,
    required this.onTap,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _BigCircle(value: value),
        _SmallCircle(
          onTap: onTap,
          leadingIcon: leadingIcon,
        ),
      ],
    );
  }
}

class _SmallCircle extends StatelessWidget {
  final Function() onTap;
  final IconData leadingIcon;

  const _SmallCircle({
    required this.onTap,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Container(
        decoration: BoxDecoration(
          color: ThemeData.light().colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          leadingIcon,
          size: 150,
          color: Theme.of(context).colorScheme.background,
        ),
      ),
      color: Theme.of(context).colorScheme.tertiary,
    );
  }
}

class _BigCircle extends StatefulWidget {
  final double value;
  final Duration? duration;

  // ignore: unused_element
  const _BigCircle({required this.value, this.duration});

  @override
  State<_BigCircle> createState() => _BigCircleState();
}

class _BigCircleState extends State<_BigCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  static const defaultDuration = Duration(seconds: 1);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? defaultDuration,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastEaseInToSlowEaseOut,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    _animationController.forward();
    return SizedBox(
      width: 150,
      height: 150,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => CustomPaint(
          painter: MiRadialProgress(
            value: widget.value * _animation.value,
            primaryColor: colors.primary,
            secondaryColor: colors.error,
          ),
        ),
      ),
    );
  }
}

class MiRadialProgress extends CustomPainter {
  final double value;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double? strokeWidth;

  MiRadialProgress({
    required this.value,
    this.primaryColor,
    this.secondaryColor,
    this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // completed circle
    final paint = Paint()
      ..strokeWidth = strokeWidth ?? 10
      ..color = secondaryColor ?? Colors.redAccent
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.5, size.height / 2);
    final radius = min(size.width * 0.5, size.height * 0.5);

    canvas.drawCircle(center, radius, paint);

    // Arc
    final paintArc = Paint()
      ..strokeWidth = strokeWidth ?? 10
      ..color = primaryColor ?? Colors.greenAccent
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // filling part of the arc
    double arcAngle = 2 * pi * (value / 100);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      arcAngle,
      false,
      paintArc,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
