import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/cart_item.dart';
import '../../../catalog/domain/models/product.dart';

class CartController extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => const <CartItem>[];

  void add(Product product, {int quantity = 1}) {
    final int count = quantity < 1 ? 1 : quantity;
    final int index = state.indexWhere(
      (CartItem item) => item.product.id == product.id,
    );
    if (index == -1) {
      state = <CartItem>[...state, CartItem(product: product, quantity: count)];
      return;
    }
    _replaceAt(
      index,
      state[index].copyWith(quantity: state[index].quantity + count),
    );
  }

  void increment(int productId) {
    final int index = _indexOf(productId);
    if (index == -1) return;
    _replaceAt(
      index,
      state[index].copyWith(quantity: state[index].quantity + 1),
    );
  }

  void decrement(int productId) {
    final int index = _indexOf(productId);
    if (index == -1) return;
    final int nextQty = state[index].quantity - 1;
    if (nextQty < 1) {
      remove(productId);
      return;
    }
    _replaceAt(index, state[index].copyWith(quantity: nextQty));
  }

  void setQuantity(int productId, int quantity) {
    if (quantity < 1) {
      remove(productId);
      return;
    }
    final int index = _indexOf(productId);
    if (index == -1) return;
    _replaceAt(index, state[index].copyWith(quantity: quantity));
  }

  void remove(int productId) {
    state = state
        .where((CartItem item) => item.product.id != productId)
        .toList(growable: false);
  }

  void clear() => state = const <CartItem>[];

  /// Puts a removed row back where it was, so undo keeps the cart order.
  void insertAt(int index, CartItem item) {
    final List<CartItem> next = List<CartItem>.from(state);
    next.insert(index.clamp(0, next.length), item);
    state = next;
  }

  int get itemCount =>
      state.fold<int>(0, (int sum, CartItem item) => sum + item.quantity);

  double get subtotal => state.fold<double>(
    0,
    (double sum, CartItem item) => sum + item.lineTotal,
  );

  int _indexOf(int productId) =>
      state.indexWhere((CartItem item) => item.product.id == productId);

  void _replaceAt(int index, CartItem item) {
    final List<CartItem> next = List<CartItem>.from(state);
    next[index] = item;
    state = next;
  }
}

final cartProvider = NotifierProvider<CartController, List<CartItem>>(
  CartController.new,
);

final cartItemCountProvider = Provider<int>((ref) {
  return ref
      .watch(cartProvider)
      .fold<int>(0, (int sum, CartItem item) => sum + item.quantity);
});
