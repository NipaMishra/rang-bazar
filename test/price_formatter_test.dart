import 'package:flutter_test/flutter_test.dart';

import 'package:rang_bazaar/core/utils/price_formatter.dart';

void main() {
  test('formats values as INR', () {
    expect(PriceFormatter.format(1299), contains('₹'));
    expect(PriceFormatter.format(1299.5), contains('1,299.50'));
  });
}
