/// Filters applied to the transaction list. Dashboard always uses all data.
enum TransactionFilter {
  all,
  income,
  expense,
}

extension TransactionFilterLabel on TransactionFilter {
  String get label {
    return switch (this) {
      TransactionFilter.all => 'All',
      TransactionFilter.income => 'Income',
      TransactionFilter.expense => 'Expense',
    };
  }
}
