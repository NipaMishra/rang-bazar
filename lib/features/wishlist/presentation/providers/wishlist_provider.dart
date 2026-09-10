import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistController extends Notifier<Set<int>> {
  @override
  Set<int> build() => <int>{};

  void toggle(int productId) {
    final Set<int> next = Set<int>.from(state);
    if (!next.add(productId)) {
      next.remove(productId);
    }
    state = next;
  }

  bool contains(int productId) => state.contains(productId);
}

final wishlistProvider = NotifierProvider<WishlistController, Set<int>>(
  WishlistController.new,
);
