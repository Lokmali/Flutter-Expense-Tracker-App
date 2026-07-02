import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import 'transaction_tile.dart';

class DismissibleTransactionTile extends StatelessWidget {
  const DismissibleTransactionTile({
    super.key,
    required this.transaction,
    required this.onDeleteConfirmed,
    required this.onDismissed,
    required this.onDeleteTap,
    required this.onTap,
  });

  final TransactionModel transaction;
  final Future<bool> Function() onDeleteConfirmed;
  final VoidCallback onDismissed;
  final VoidCallback onDeleteTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<String>(transaction.id),
      direction: DismissDirection.horizontal,
      dragStartBehavior: DragStartBehavior.down,
      confirmDismiss: (_) => onDeleteConfirmed(),
      onDismissed: (_) => onDismissed(),
      background: const _DeleteBackground(alignment: Alignment.centerLeft),
      secondaryBackground: const _DeleteBackground(alignment: Alignment.centerRight),
      child: TransactionTile(
        transaction: transaction,
        onTap: onTap,
        onDelete: onDeleteTap,
      ),
    );
  }
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
