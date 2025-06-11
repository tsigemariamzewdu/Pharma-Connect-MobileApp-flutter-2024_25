import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';

class PharmacyApi {
  final Dio dio;
  static const String _baseUrl = '/pharmacies';

  PharmacyApi(this.dio);

  Future<List<Pharmacy>> getAll() async {
    try {
      final response = await dio.get(_baseUrl);
      if (response.data['success'] == true) {
        final List data = response.data['data'];
        return data.map((json) => Pharmacy.fromJson(json)).toList();
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch pharmacies');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          e.message ??
          'Failed to fetch pharmacies');
    }
  }

  Future<Pharmacy> add(Pharmacy pharmacy) async {
    try {
      final response = await dio.post(_baseUrl, data: pharmacy.toJson());
      if (response.data['success'] == true) {
        return Pharmacy.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to add pharmacy');
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? e.message ?? 'Failed to add pharmacy');
    }
  }

  Future<Pharmacy> update(String id, Pharmacy pharmacy) async {
    try {
      final response = await dio.put('$_baseUrl/$id', data: pharmacy.toJson());
      if (response.data['success'] == true) {
        return Pharmacy.fromJson(response.data['data']);
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to update pharmacy');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          e.message ??
          'Failed to update pharmacy');
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/$id');
      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Failed to delete pharmacy');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ??
          e.message ??
          'Failed to delete pharmacy');
    }
  }
}
