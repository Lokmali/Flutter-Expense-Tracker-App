class TransactionModel {
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final DateTime date;

  const TransactionModel({
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.date,
  });

  @override
  String toString() {
    return 'TransactionModel(title: $title, amount: $amount, category: $category, isIncome: $isIncome, date: $date)';
  }
}
