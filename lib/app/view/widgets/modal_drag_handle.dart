import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModalDragHandle extends StatelessWidget {
  final VoidCallback? onDragStart;
  final Function(DragStartDetails)? onVerticalDragStart;
  final Function(DragUpdateDetails, double)? onVerticalDragUpdate;
  final String title;

  const ModalDragHandle({
    super.key,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.title = 'Drag',
    this.onDragStart,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onVerticalDragStart: onVerticalDragStart,
      onVerticalDragUpdate: (details) {
        if (onVerticalDragUpdate != null) {
          onVerticalDragUpdate!(details, screenHeight);
        }
      },
      child: Container(
        color: Colors.transparent, // Hit test area
        width: double.infinity,
        child: Column(
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
