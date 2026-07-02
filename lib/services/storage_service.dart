import 'package:hive_flutter/hive_flutter.dart';

import '../models/transaction_model.dart';

class StorageService {
  StorageService({Box? box}) : _injectedBox = box;

  static const boxName = 'transactions';
  static const listKey = 'transaction_list';

  final Box? _injectedBox;
  Box? _box;

  Future<void> init() async {
    _box ??= _injectedBox ?? await Hive.openBox(boxName);
  }

  Box get box {
    final hiveBox = _box;
    if (hiveBox == null || !hiveBox.isOpen) {
      throw StateError('StorageService is not initialized. Call init() first.');
    }
    return hiveBox;
  }

  Future<List<TransactionModel>> loadTransactions() async {
    final storedData = box.get(listKey, defaultValue: <dynamic>[]) as List;

    return storedData.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      final id = map.remove('id') as String?;
      return TransactionModel.fromMap(map, id: id);
    }).toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final serialized = transactions.map((transaction) {
      return {
        'id': transaction.id,
        ...transaction.toMap(),
      };
    }).toList();

    await box.put(listKey, serialized);
  }
}
