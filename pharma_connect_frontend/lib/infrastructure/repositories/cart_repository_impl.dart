import 'package:dartz/dartz.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';
import 'package:pharma_connect_flutter/domain/repositories/cart_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/cart_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/api_client.dart';

class CartRepositoryImpl implements CartRepository {
  final CartApi api;

  CartRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await api.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addItem(CartItem item) async {
    try {
      final items = await api.addItem(item.inventoryId);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> removeItem(String itemId) async {
    try {
      // itemId should be inventoryId, but we also need pharmacyId and medicineId
      // For now, assume itemId is inventoryId and fetch the item from the cart
      final cartItems = await api.getCartItems();
      final item = cartItems.firstWhere((i) => i.inventoryId == itemId);
      final items = await api.removeItem(item.pharmacyId, item.medicineId);
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> updateQuantity(
      String itemId, int quantity) async {
    // Not supported by backend
    return Left(ServerFailure('Update quantity not supported'));
  }

  @override
  Future<Either<Failure, List<CartItem>>> clearCart() async {
    try {
      final items = await api.clearCart();
      return Right(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> checkout() async {
    // Not supported by backend
    return Left(ServerFailure('Checkout not supported'));
  }
}

final cartRepositoryProvider = Provider<CartRepositoryImpl>((ref) {
  final api = ref.watch(cartApiProvider);
  return CartRepositoryImpl(api);
});
