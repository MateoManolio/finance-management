import 'package:flutter/material.dart';
import '../../domain/expense.dart';
import 'circle.dart';

class ExpenseWidget extends StatelessWidget {
  final Expense expense;

  const ExpenseWidget({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Leading(expense: expense),
        _Price(
          price: expense.value,
        ),
      ],
    );
  }
}

class _Leading extends StatelessWidget {
  final Expense expense;
  final double? padding;
  const _Leading({super.key, required this.expense, this.padding});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Circle(),
        SizedBox(
          width: padding ?? 15,
        ),
        _Name(
          name: 'Home',
          description: expense.note,
        ),
      ],
    );
  }
}

class _Name extends StatelessWidget {
  final String name;
  final String description;
  final IconData? icon;

  const _Name({
    super.key,
    required this.name,
    required this.description,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.edit_note_rounded,
              color: Colors.white,
            ),
            Text(
              description,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _Price extends StatelessWidget {
  final double price;
  const _Price({required this.price});

  @override
  Widget build(BuildContext context) => Text(
        price.toString(),
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w300, color: Colors.white),
      );
}
