import 'package:flutter/material.dart';

import 'animated_amount_text.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.amount,
  });

  final String amount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Card(
        elevation: 3,
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 10),
              AnimatedAmountText(
                amount: amount,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
