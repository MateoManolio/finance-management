import 'package:flutter/material.dart';

/// Model representing a navigation item in the bottom navigation bar
class NavigationItemModel {
  /// The icon to display for the navigation item
  final IconData icon;

  /// The label text to display below the icon
  final String label;

  /// Optional badge count to display on the icon
  final int? badgeCount;

  const NavigationItemModel({
    required this.icon,
    required this.label,
    this.badgeCount,
  });
}
