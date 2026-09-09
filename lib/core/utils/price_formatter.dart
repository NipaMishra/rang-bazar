import 'package:intl/intl.dart';

abstract final class PriceFormatter {
  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  static String format(num value) => _inr.format(value);
}
