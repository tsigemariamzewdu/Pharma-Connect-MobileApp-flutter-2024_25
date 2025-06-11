import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/core/constants.dart';

class PharmacyApi {
  final Dio dio;
  final String baseUrl;

  PharmacyApi({required this.dio, this.baseUrl = '/pharmacies'});

  Future<Pharmacy> getPharmacy(String id) async {
    final response = await dio.get('$baseUrl/$id');
    if (response.data['success'] == true) {
      return Pharmacy.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load pharmacy');
    }
  }

  Future<Pharmacy> updatePharmacy(String id, Map<String, dynamic> data) async {
    final response = await dio.patch('$baseUrl/$id', data: data);
    if (response.data['success'] == true) {
      return Pharmacy.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to update pharmacy');
    }
  }

  Future<void> deletePharmacy(String id) async {
    final response = await dio.delete('$baseUrl/$id');
    if (response.data['success'] != true) {
      throw Exception(response.data['message'] ?? 'Failed to delete pharmacy');
    }
  }

  Future<List<Pharmacy>> getPharmacies() async {
    final response = await dio.get(baseUrl);
    if (response.data['success'] == true) {
      final List data = response.data['data'];
      return data.map((json) => Pharmacy.fromJson(json)).toList();
    } else {
      throw Exception(response.data['message'] ?? 'Failed to load pharmacies');
    }
  }

  Future<Pharmacy> addPharmacy(Pharmacy pharmacy) async {
    final response = await dio.post(baseUrl, data: pharmacy.toJson());
    if (response.data['success'] == true) {
      return Pharmacy.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message'] ?? 'Failed to add pharmacy');
    }
  }
}
