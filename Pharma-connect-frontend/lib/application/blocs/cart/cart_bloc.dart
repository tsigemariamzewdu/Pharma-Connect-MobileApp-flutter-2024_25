import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharma_connect_flutter/domain/entities/cart/cart_item.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine_search_result.dart';
import 'package:uuid/uuid.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState.initial()) {
    on<_AddItem>((event, emit) => _onAddItem(event.medicine, emit));
    on<_RemoveItem>((event, emit) => _onRemoveItem(event.itemId, emit));
    on<_UpdateQuantity>(
        (event, emit) => _onUpdateQuantity(event.itemId, event.quantity, emit));
    on<_ClearCart>((event, emit) => _onClearCart(emit));
  }

  void _onAddItem(MedicineSearchResult medicine, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is _Loaded) {
      final existingItemIndex = currentState.items.indexWhere(
        (item) => item.medicine.pharmacyId == medicine.pharmacyId,
      );

      if (existingItemIndex != -1) {
        final existingItem = currentState.items[existingItemIndex];
        final updatedItems = [...currentState.items];
        updatedItems[existingItemIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
        emit(CartState.loaded(updatedItems));
        print('Cart State (added item): ${state}');
      } else {
        final newItem = CartItem(
          id: const Uuid().v4(),
          medicine: medicine,
          quantity: 1,
          price: medicine.price,
        );
        final updatedItems = [...currentState.items, newItem];
        emit(CartState.loaded(updatedItems));
        print('Cart State (new item): ${state}');
      }
    } else {
      final newItem = CartItem(
        id: const Uuid().v4(),
        medicine: medicine,
        quantity: 1,
        price: medicine.price,
      );
      emit(CartState.loaded([newItem]));
      print('Cart State (first item): ${state}');
    }
  }

  void _onRemoveItem(String itemId, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is _Loaded) {
      final updatedItems =
          currentState.items.where((item) => item.id != itemId).toList();
      if (updatedItems.isEmpty) {
        emit(const CartState.initial());
      } else {
        emit(CartState.loaded(updatedItems));
      }
    }
  }

  void _onUpdateQuantity(String itemId, int quantity, Emitter<CartState> emit) {
    final currentState = state;
    if (currentState is _Loaded) {
      final updatedItems = currentState.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList();
      emit(CartState.loaded(updatedItems));
    }
  }

  void _onClearCart(Emitter<CartState> emit) {
    emit(const CartState.initial());
  }
}
