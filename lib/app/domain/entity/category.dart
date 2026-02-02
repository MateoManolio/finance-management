import 'package:flutter/material.dart';

class Category {
  final int? id;
  final String name;
  final IconData icon;
  final String? group;
  final Color? color;
  final int? parentId;
  final int displayOrder;

  Category({
    this.id,
    required this.name,
    required this.icon,
    this.group,
    this.color,
    this.parentId,
    this.displayOrder = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
