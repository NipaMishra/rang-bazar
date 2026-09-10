import 'package:flutter_test/flutter_test.dart';

import 'package:rang_bazaar/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
    });

    test('rejects invalid format', () {
      expect(Validators.email('plain'), isNotNull);
      expect(Validators.email('missing@domain'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
    });

    test('accepts valid email', () {
      expect(Validators.email('shopper@rangbazaar.in'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('rejects short passwords', () {
      expect(Validators.password('12345'), isNotNull);
    });

    test('accepts minimum length', () {
      expect(Validators.password('secret'), isNull);
    });
  });
}
