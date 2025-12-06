import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;
  final String? group;
  final Color? color;

  Category({
    required this.name,
    required this.icon,
    this.group,
    this.color,
  });
}
