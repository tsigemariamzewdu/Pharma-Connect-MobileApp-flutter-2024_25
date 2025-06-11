import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/medicine_api.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/pharmacy_api.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/auth_api.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/inventory_api.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/application_api.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/medicine_api.dart'
    as remote;
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/pharmacy_api.dart'
    as remote_pharmacy;
import 'package:pharma_connect_flutter/infrastructure/datasources/cart_api.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.4.113.71:5000/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
  return dio;
});

class ApiClient {
  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.4.113.71:5000/api/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}

final medicineApiProvider = Provider<remote.MedicineApi>((ref) {
  final dio = ref.watch(dioProvider);
  return remote.MedicineApi(dio: dio);
});

final pharmacyApiProvider = Provider<remote_pharmacy.PharmacyApi>((ref) {
  final dio = ref.watch(dioProvider);
  return remote_pharmacy.PharmacyApi(dio: dio);
});

final authApiProvider = Provider<AuthApi>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthApi(dio);
});

final inventoryApiProvider = Provider<InventoryApi>((ref) {
  final dio = ref.watch(dioProvider);
  return InventoryApi(dio: dio);
});

final applicationApiProvider = Provider<ApplicationApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ApplicationApi(dio: dio);
});

final cartApiProvider = Provider<CartApi>((ref) {
  final dio = ref.watch(dioProvider);
  return CartApi(dio);
});
