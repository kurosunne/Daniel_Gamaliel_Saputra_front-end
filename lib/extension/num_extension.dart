import 'package:intl/intl.dart';

extension NumExtension on num {
  String formatIDR(int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(this);
  }
}
