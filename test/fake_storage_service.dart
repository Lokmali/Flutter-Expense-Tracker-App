import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/services/storage_service.dart';

class FakeStorageService extends StorageService {
  FakeStorageService({List<TransactionModel>? initialTransactions})
      : _transactions = List<TransactionModel>.from(initialTransactions ?? []);

  final List<TransactionModel> _transactions;

  @override
  Future<void> init() async {}

  @override
  Future<List<TransactionModel>> loadTransactions() async {
    return List<TransactionModel>.from(_transactions);
  }

  @override
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    _transactions
      ..clear()
      ..addAll(transactions);
  }
}
