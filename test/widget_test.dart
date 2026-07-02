import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/models/transaction_model.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/utils/formatters.dart';

import 'fake_storage_service.dart';

Future<void> pumpHomeScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    HomeScreen(storageService: FakeStorageService()),
  );
  await tester.pumpAndSettle();
}

Future<void> _addTransaction(
  WidgetTester tester, {
  required String title,
  required String amount,
}) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.widgetWithText(TextFormField, 'Transaction Title'),
    title,
  );
  await tester.enterText(
    find.widgetWithText(TextFormField, 'Amount'),
    amount,
  );
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('HomeScreen shows dashboard empty state', (WidgetTester tester) async {
    await pumpHomeScreen(tester);

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('₹0.00'), findsNWidgets(3));
    expect(find.text('Income'), findsNWidgets(2));
    expect(find.text('Expense'), findsNWidgets(2));
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('No Transactions Yet'), findsOneWidget);
    expect(
      find.text('Start tracking your expenses by tapping the + button.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('FAB navigates to Add Transaction screen', (WidgetTester tester) async {
    await pumpHomeScreen(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add Transaction'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Saved transaction updates dashboard and list', (WidgetTester tester) async {
    await pumpHomeScreen(tester);

    await _addTransaction(tester, title: 'Lunch', amount: '250');

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.textContaining('Food'), findsOneWidget);
    expect(find.text('-₹250.00'), findsNWidgets(2));
    expect(find.text('₹250.00'), findsOneWidget);
    expect(find.text('No Transactions Yet'), findsNothing);
  });

  testWidgets('Deleting transaction updates dashboard and shows empty state',
      (WidgetTester tester) async {
    await pumpHomeScreen(tester);
    await _addTransaction(tester, title: 'Lunch', amount: '250');

    await tester.drag(find.text('Lunch'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Delete Transaction'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Lunch'), findsNothing);
    expect(find.text('Transaction deleted.'), findsOneWidget);
    expect(find.text('₹0.00'), findsNWidgets(3));
    expect(find.text('No Transactions Yet'), findsOneWidget);
  });

  testWidgets('Undo restores deleted transaction', (WidgetTester tester) async {
    await pumpHomeScreen(tester);
    await _addTransaction(tester, title: 'Lunch', amount: '250');

    await tester.drag(find.text('Lunch'), const Offset(500, 0));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('₹250.00'), findsOneWidget);
    expect(find.text('No Transactions Yet'), findsNothing);
  });

  testWidgets('HomeScreen loads saved transactions on startup', (WidgetTester tester) async {
    final storageService = FakeStorageService(
      initialTransactions: [
        TransactionModel(
          id: 'saved-1',
          title: 'Saved Salary',
          amount: 5000,
          category: 'Salary',
          isIncome: true,
          date: DateTime(2026, 7, 3),
        ),
      ],
    );

    await tester.pumpWidget(HomeScreen(storageService: storageService));
    await tester.pumpAndSettle();

    expect(find.text('Saved Salary'), findsOneWidget);
    expect(find.text('+₹5,000.00'), findsOneWidget);
    expect(find.text('₹5,000.00'), findsNWidgets(2));
    expect(find.text('No Transactions Yet'), findsNothing);
  });

  testWidgets('Tapping a transaction opens edit screen', (WidgetTester tester) async {
    await pumpHomeScreen(tester);
    await _addTransaction(tester, title: 'Lunch', amount: '250');

    await tester.tap(find.text('Lunch'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Transaction'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Transaction Title'),
      'Updated Lunch',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Updated Lunch'), findsOneWidget);
    expect(find.text('Lunch'), findsNothing);
  });

  testWidgets('Search filters transactions by title', (WidgetTester tester) async {
    await pumpHomeScreen(tester);
    await _addTransaction(tester, title: 'Lunch', amount: '250');
    await _addTransaction(tester, title: 'Bus Fare', amount: '50');

    await tester.tap(find.byTooltip('Search transactions'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Bus');
    await tester.pumpAndSettle();

    expect(find.text('Bus Fare'), findsOneWidget);
    expect(find.text('Lunch'), findsNothing);
  });

  testWidgets('Filter chips show only income transactions', (WidgetTester tester) async {
    final storageService = FakeStorageService(
      initialTransactions: [
        TransactionModel(
          id: '1',
          title: 'Lunch',
          amount: 250,
          category: 'Food',
          isIncome: false,
          date: DateTime(2026, 7, 3),
        ),
        TransactionModel(
          id: '2',
          title: 'Salary',
          amount: 5000,
          category: 'Salary',
          isIncome: true,
          date: DateTime(2026, 7, 2),
        ),
      ],
    );

    await tester.pumpWidget(HomeScreen(storageService: storageService));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilterChip, 'Income'));
    await tester.pumpAndSettle();

    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Lunch'), findsNothing);
    expect(find.text('₹5,000.00'), findsOneWidget);
    expect(find.text('+₹5,000.00'), findsOneWidget);
  });

  test('Formatters formats currency and date correctly', () {
    expect(Formatters.formatCurrency(12500), '₹12,500.00');
    expect(Formatters.formatDate(DateTime(2026, 7, 3)), '03 Jul 2026');
  });

  test('TransactionModel map conversion works', () {
    final transaction = TransactionModel(
      id: 'test-id',
      title: 'Coffee',
      amount: 120,
      category: 'Food',
      isIncome: false,
      date: DateTime(2026, 7, 3, 10, 30),
    );

    final restored = TransactionModel.fromMap(
      transaction.toMap(),
      id: transaction.id,
    );

    expect(restored.id, transaction.id);
    expect(restored.title, transaction.title);
    expect(restored.amount, transaction.amount);
    expect(restored.category, transaction.category);
    expect(restored.isIncome, transaction.isIncome);
    expect(restored.date, transaction.date);
  });

  test('TransactionModel preserves provided id', () {
    final transaction = TransactionModel(
      id: 'test-id',
      title: 'A',
      amount: 10,
      category: 'Food',
      isIncome: false,
      date: DateTime(2026, 7, 3),
    );

    expect(transaction.id, 'test-id');
  });
}
