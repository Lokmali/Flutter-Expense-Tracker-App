import 'package:flutter/material.dart';

import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String formatDate(DateTime date) {
    final localDate = date.toLocal();
    final day = localDate.day.toString().padLeft(2, '0');
    final month = _months[localDate.month - 1];
    return '$day $month ${localDate.year}';
  }

  static IconData categoryIcon(String category) {
    return switch (category) {
      'Food' => Icons.restaurant_outlined,
      'Shopping' => Icons.shopping_bag_outlined,
      'Salary' => Icons.work_outline,
      'Transport' => Icons.directions_car_outlined,
      'Entertainment' => Icons.movie_outlined,
      _ => Icons.more_horiz,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIncome = transaction.isIncome;
    final amountColor =
        isIncome ? Colors.green.shade600 : Colors.red.shade600;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: colorScheme.surfaceContainerHighest,
        child: Icon(
          categoryIcon(transaction.category),
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${transaction.category} • ${formatDate(transaction.date)}',
        style: TextStyle(color: colorScheme.onSurfaceVariant),
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'}₹${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: amountColor,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}
