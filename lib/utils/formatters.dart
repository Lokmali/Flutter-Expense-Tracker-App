import 'package:intl/intl.dart';

/// Centralized currency and date formatting for consistent display.
class Formatters {
  Formatters._();

  static final NumberFormat currency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static final DateFormat date = DateFormat('dd MMM yyyy');

  static String formatCurrency(double amount) => currency.format(amount);

  static String formatSignedCurrency(double amount, {required bool isIncome}) {
    final prefix = isIncome ? '+' : '-';
    return '$prefix${currency.format(amount)}';
  }

  static String formatDate(DateTime value) => date.format(value.toLocal());
}
