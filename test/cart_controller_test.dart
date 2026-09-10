import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rang_bazaar/features/cart/domain/cart_item.dart';
import 'package:rang_bazaar/features/cart/presentation/providers/cart_provider.dart';
import 'package:rang_bazaar/features/catalog/domain/models/product.dart';

Product _product(int id, {double price = 199.5}) {
  return Product(
    id: id,
    title: 'Product $id',
    price: price,
    description: 'A sample product',
    category: 'electronics',
    image: 'https://example.com/$id.png',
    rating: const Rating(rate: 4.2, count: 80),
  );
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  CartController cart() => container.read(cartProvider.notifier);

  test('adds a new product as a single row', () {
    cart().add(_product(1));
    expect(container.read(cartProvider), hasLength(1));
    expect(container.read(cartProvider).first.quantity, 1);
  });

  test('adding the same product increments quantity', () {
    final Product product = _product(1);
    cart().add(product);
    cart().add(product);
    expect(container.read(cartProvider), hasLength(1));
    expect(container.read(cartProvider).first.quantity, 2);
  });

  test('increment and decrement update quantity', () {
    cart().add(_product(1));
    cart().increment(1);
    expect(container.read(cartProvider).first.quantity, 2);
    cart().decrement(1);
    expect(container.read(cartProvider).first.quantity, 1);
  });

  test('decrement below 1 removes the item', () {
    cart().add(_product(1));
    cart().decrement(1);
    expect(container.read(cartProvider), isEmpty);
  });

  test('remove deletes the row', () {
    cart().add(_product(1));
    cart().add(_product(2));
    cart().remove(1);
    expect(container.read(cartProvider), hasLength(1));
    expect(container.read(cartProvider).first.product.id, 2);
  });

  test('setQuantity replaces the row count', () {
    cart().add(_product(1));
    cart().setQuantity(1, 5);
    expect(container.read(cartProvider).first.quantity, 5);
    cart().setQuantity(1, 0);
    expect(container.read(cartProvider), isEmpty);
  });

  test('clear empties the cart after checkout', () {
    cart().add(_product(1));
    cart().add(_product(2), quantity: 3);
    cart().clear();
    expect(container.read(cartProvider), isEmpty);
    expect(container.read(cartItemCountProvider), 0);
  });

  test('insertAt restores a removed row in place', () {
    cart().add(_product(1));
    cart().add(_product(2));
    cart().add(_product(3));
    final CartItem removed = container.read(cartProvider)[1];
    cart().remove(2);
    cart().insertAt(1, removed);
    expect(
      container
          .read(cartProvider)
          .map((CartItem item) => item.product.id)
          .toList(),
      <int>[1, 2, 3],
    );
  });

  test('subtotal uses quantity times price', () {
    cart().add(_product(1, price: 100));
    cart().add(_product(1, price: 100));
    cart().add(_product(2, price: 50));
    expect(cart().subtotal, 250);
    expect(container.read(cartItemCountProvider), 3);
  });
}
