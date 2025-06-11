import 'package:dartz/dartz.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, List<CartItem>>> addItem(CartItem item);
  Future<Either<Failure, List<CartItem>>> removeItem(String itemId);
  Future<Either<Failure, List<CartItem>>> updateQuantity(String itemId, int quantity);
  Future<Either<Failure, List<CartItem>>> clearCart();
  Future<Either<Failure, List<CartItem>>> checkout();
}
