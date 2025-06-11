import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/cart_repository_impl.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';

class CartNotifier extends StateNotifier<AsyncValue<List<CartItem>>> {
  final CartRepositoryImpl repository;
  CartNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = const AsyncValue.loading();
    final result = await repository.getCartItems();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (items) => state = AsyncValue.data(items),
    );
  }

  Future<void> addItem(CartItem item) async {
    state = const AsyncValue.loading();
    final result = await repository.addItem(item);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (items) => state = AsyncValue.data(items),
    );
  }

  Future<void> removeItem(String itemId) async {
    state = const AsyncValue.loading();
    final result = await repository.removeItem(itemId);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (items) => state = AsyncValue.data(items),
    );
  }

  Future<void> clearCart() async {
    state = const AsyncValue.loading();
    final result = await repository.clearCart();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (items) => state = AsyncValue.data(items),
    );
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifier, AsyncValue<List<CartItem>>>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return CartNotifier(repository);
});
