import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharma_connect_flutter/domain/entities/order/order.dart';
import 'package:pharma_connect_flutter/domain/repositories/order_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';
part 'orders_bloc.freezed.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository repository;

  OrdersBloc(this.repository) : super(const OrdersState.initial()) {
    on<OrdersEvent>((event, emit) async {
      await event.map(
        loadOrders: (e) => _onLoadOrders(e, emit),
        refreshOrders: (e) => _onRefreshOrders(e, emit),
      );
    });
  }

  Future<void> _onLoadOrders(_LoadOrders event, Emitter<OrdersState> emit) async {
    emit(const OrdersState.loading());
    final result = await repository.getOrders();
    result.fold(
      (failure) => emit(OrdersState.error(failure.message)),
      (orders) => emit(OrdersState.loaded(orders)),
    );
  }

  Future<void> _onRefreshOrders(_RefreshOrders event, Emitter<OrdersState> emit) async {
    final result = await repository.getOrders();
    result.fold(
      (failure) => emit(OrdersState.error(failure.message)),
      (orders) => emit(OrdersState.loaded(orders)),
    );
  }
} 