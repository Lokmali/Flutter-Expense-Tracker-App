import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../widgets/transaction_tile.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      home: const _HomeDashboard(),
    );
  }
}

class _HomeDashboard extends StatefulWidget {
  const _HomeDashboard();

  @override
  State<_HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<_HomeDashboard> {
  final List<TransactionModel> _transactions = [];

  double get _totalIncome => _transactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get _totalExpense => _transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get _totalBalance => _totalIncome - _totalExpense;

  String _formatCurrency(double amount) => '₹${amount.toStringAsFixed(2)}';

  Future<void> _openAddTransaction() async {
    final transaction = await Navigator.push<TransactionModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (transaction != null) {
      setState(() => _transactions.add(transaction));
    }
  }

  List<TransactionModel> get _sortedTransactions {
    final sorted = List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sortedTransactions = _sortedTransactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BalanceCard(amount: _formatCurrency(_totalBalance)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Income',
                    amount: _formatCurrency(_totalIncome),
                    icon: Icons.arrow_downward_rounded,
                    iconColor: Colors.green.shade600,
                    backgroundColor: Colors.green.shade50,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryCard(
                    label: 'Expense',
                    amount: _formatCurrency(_totalExpense),
                    icon: Icons.arrow_upward_rounded,
                    iconColor: Colors.red.shade600,
                    backgroundColor: Colors.red.shade50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            if (sortedTransactions.isEmpty)
              const _EmptyTransactionsCard()
            else
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (var i = 0; i < sortedTransactions.length; i++) ...[
                      TransactionTile(transaction: sortedTransactions[i]),
                      if (i < sortedTransactions.length - 1)
                        const Divider(height: 1),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              amount,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final String label;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTransactionsCard extends StatelessWidget {
  const _EmptyTransactionsCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to add your first transaction.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
