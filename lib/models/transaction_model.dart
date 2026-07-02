class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final String category;
  final bool isIncome;
  final DateTime date;

  TransactionModel({
    String? id,
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.date,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'isIncome': isIncome,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TransactionModel(
      id: id,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      isIncome: map['isIncome'] as bool,
      date: DateTime.parse(map['date'] as String),
    );
  }

  TransactionModel copyWith({
    String? title,
    double? amount,
    String? category,
    bool? isIncome,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, amount: $amount, category: $category, isIncome: $isIncome, date: $date)';
  }
}
