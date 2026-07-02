import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/widgets/transaction_tile.dart';

void main() {
  testWidgets('HomeScreen shows dashboard empty state', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeScreen());

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('₹0.00'), findsNWidgets(3));
    expect(find.text('Income'), findsOneWidget);
    expect(find.text('Expense'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text('Tap the + button to add your first transaction.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('FAB navigates to Add Transaction screen', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeScreen());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Add Transaction'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Saved transaction updates dashboard and list', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeScreen());

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Transaction Title'),
      'Lunch',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Amount'),
      '250',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Lunch'), findsOneWidget);
    expect(find.textContaining('Food'), findsOneWidget);
    expect(find.text('-₹250.00'), findsOneWidget);
    expect(find.text('₹250.00'), findsOneWidget);
    expect(find.text('No transactions yet'), findsNothing);
  });

  test('TransactionTile formats date correctly', () {
    final formatted = TransactionTile.formatDate(DateTime(2026, 7, 3));
    expect(formatted, '03 Jul 2026');
  });
}
