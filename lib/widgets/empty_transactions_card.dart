import 'package:flutter/material.dart';

/// Empty state shown when there are no transactions at all.
class EmptyTransactionsCard extends StatelessWidget {
  const EmptyTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 72,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 20),
            Text(
              'No Transactions Yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Start tracking your expenses by tapping the + button.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Empty state shown when search/filter returns no results.
class NoMatchingTransactionsCard extends StatelessWidget {
  const NoMatchingTransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 56,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No matching transactions found.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
