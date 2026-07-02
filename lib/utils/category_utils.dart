import 'package:flutter/material.dart';

/// Shared category definitions, icons, and colors used across the app.
class CategoryUtils {
  CategoryUtils._();

  static const categories = [
    'Food',
    'Shopping',
    'Salary',
    'Transport',
    'Entertainment',
    'Health',
    'Education',
    'Bills',
    'Other',
  ];

  static IconData iconFor(String category) {
    return switch (category) {
      'Food' => Icons.restaurant_outlined,
      'Shopping' => Icons.shopping_bag_outlined,
      'Salary' => Icons.account_balance_wallet_outlined,
      'Transport' => Icons.directions_car_outlined,
      'Entertainment' => Icons.movie_outlined,
      'Health' => Icons.favorite_outline,
      'Education' => Icons.school_outlined,
      'Bills' => Icons.receipt_long_outlined,
      _ => Icons.more_horiz,
    };
  }

  static Color colorFor(String category) {
    return switch (category) {
      'Food' => const Color(0xFFFF9800),
      'Shopping' => const Color(0xFF9C27B0),
      'Salary' => const Color(0xFF4CAF50),
      'Transport' => const Color(0xFF2196F3),
      'Entertainment' => const Color(0xFFE91E63),
      'Health' => const Color(0xFFF44336),
      'Education' => const Color(0xFF3F51B5),
      'Bills' => const Color(0xFF795548),
      _ => const Color(0xFF607D8B),
    };
  }
}
