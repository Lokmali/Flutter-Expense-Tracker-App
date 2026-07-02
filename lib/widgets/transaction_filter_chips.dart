import 'package:flutter/material.dart';

import '../models/transaction_filter.dart';

class TransactionFilterChips extends StatelessWidget {
  const TransactionFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  final TransactionFilter selectedFilter;
  final ValueChanged<TransactionFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TransactionFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              child: FilterChip(
                label: Text(filter.label),
                selected: isSelected,
                showCheckmark: false,
                onSelected: (_) => onFilterChanged(filter),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
