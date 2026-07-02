import 'package:flutter/material.dart';

import '../models/transaction_filter.dart';
import '../models/transaction_model.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';
import '../widgets/balance_card.dart';
import '../widgets/dismissible_transaction_tile.dart';
import '../widgets/empty_transactions_card.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_filter_chips.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.storageService,
  });

  final StorageService storageService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: _HomeDashboard(storageService: storageService),
    );
  }
}

class _HomeDashboard extends StatefulWidget {
  const _HomeDashboard({required this.storageService});

  final StorageService storageService;

  @override
  State<_HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<_HomeDashboard> {
  final List<TransactionModel> _transactions = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  String _searchQuery = '';
  TransactionFilter _selectedFilter = TransactionFilter.all;

  StorageService get _storageService => widget.storageService;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadTransactions();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
  }

  Future<void> _loadTransactions() async {
    final transactions = await _storageService.loadTransactions();
    if (!mounted) {
      return;
    }

    setState(() {
      _transactions
        ..clear()
        ..addAll(transactions);
    });
  }

  Future<void> _persistTransactions() async {
    await _storageService.saveTransactions(_transactions);
  }

  void _updateTransactions(VoidCallback update) {
    setState(update);
    _persistTransactions();
  }

  double get _totalIncome => _transactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get _totalExpense => _transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get _totalBalance => _totalIncome - _totalExpense;

  List<TransactionModel> get _sortedTransactions {
    return List<TransactionModel>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  List<TransactionModel> get _visibleTransactions {
    return _sortedTransactions.where((transaction) {
      final matchesFilter = switch (_selectedFilter) {
        TransactionFilter.all => true,
        TransactionFilter.income => transaction.isIncome,
        TransactionFilter.expense => !transaction.isIncome,
      };

      if (!matchesFilter) {
        return false;
      }

      if (_searchQuery.isEmpty) {
        return true;
      }

      return transaction.title.toLowerCase().contains(_searchQuery) ||
          transaction.category.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  Future<void> _openAddTransaction() async {
    final transaction = await Navigator.push<TransactionModel>(
      context,
      buildTransactionRoute(const AddTransactionScreen()),
    );

    if (transaction != null) {
      _updateTransactions(() => _transactions.add(transaction));
    }
  }

  Future<void> _openEditTransaction(TransactionModel transaction) async {
    final updated = await Navigator.push<TransactionModel>(
      context,
      buildTransactionRoute(
        AddTransactionScreen(transaction: transaction),
      ),
    );

    if (updated != null) {
      _updateTransactions(() {
        final index =
            _transactions.indexWhere((item) => item.id == updated.id);
        if (index != -1) {
          _transactions[index] = updated;
        }
      });
    }
  }

  Future<bool> _confirmDeleteTransaction() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    return shouldDelete ?? false;
  }

  void _deleteTransaction(TransactionModel transaction) {
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index == -1) {
      return;
    }

    _updateTransactions(() => _transactions.removeAt(index));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _updateTransactions(() => _transactions.insert(index, transaction));
          },
        ),
      ),
    );
  }

  Future<void> _handleDeleteTap(TransactionModel transaction) async {
    final shouldDelete = await _confirmDeleteTransaction();
    if (shouldDelete) {
      _deleteTransaction(transaction);
    }
  }

  PreferredSizeWidget _buildAppBar() {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search by title or category...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _searchController.clear,
            ),
        ],
      );
    }

    return AppBar(
      title: const Text('Expense Tracker'),
      actions: [
        IconButton(
          tooltip: 'Search transactions',
          icon: const Icon(Icons.search),
          onPressed: () => setState(() => _isSearching = true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = _visibleTransactions;
    final hasAnyTransactions = _transactions.isNotEmpty;

    return Scaffold(
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BalanceCard(amount: Formatters.formatCurrency(_totalBalance)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: 'Income',
                          amount: Formatters.formatCurrency(_totalIncome),
                          icon: Icons.arrow_downward_rounded,
                          iconColor: const Color(0xFF2E7D32),
                          backgroundColor: const Color(0xFFE8F5E9),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SummaryCard(
                          label: 'Expense',
                          amount: Formatters.formatCurrency(_totalExpense),
                          icon: Icons.arrow_upward_rounded,
                          iconColor: const Color(0xFFC62828),
                          backgroundColor: const Color(0xFFFFEBEE),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  TransactionFilterChips(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (!hasAnyTransactions)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverToBoxAdapter(
                child: EmptyTransactionsCard(),
              ),
            )
          else if (visibleTransactions.isEmpty)
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverToBoxAdapter(
                child: NoMatchingTransactionsCard(),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              sliver: SliverList(
                key: ValueKey<String>(
                  '${_selectedFilter.name}-$_searchQuery-${visibleTransactions.length}',
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final transaction = visibleTransactions[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(
                        milliseconds: 250 + (index * 40).clamp(0, 200),
                      ),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: index < visibleTransactions.length - 1 ? 12 : 0,
                        ),
                        child: DismissibleTransactionTile(
                          transaction: transaction,
                          onDeleteConfirmed: _confirmDeleteTransaction,
                          onDismissed: () => _deleteTransaction(transaction),
                          onDeleteTap: () => _handleDeleteTap(transaction),
                          onTap: () => _openEditTransaction(transaction),
                        ),
                      ),
                    );
                  },
                  childCount: visibleTransactions.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add-transaction-fab',
        onPressed: _openAddTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
