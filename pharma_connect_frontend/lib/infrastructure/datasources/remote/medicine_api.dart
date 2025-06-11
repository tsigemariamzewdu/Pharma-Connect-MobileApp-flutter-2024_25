import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';

class MedicineApi {
  final Dio dio;
  final String baseUrl;

  MedicineApi({required this.dio, this.baseUrl = '/medicines'});

  Future<Response> getMedicines() async {
    return await dio.get(baseUrl);
  }

  Future<Response> getMedicineById(String id) async {
    return await dio.get('$baseUrl/$id');
  }

  Future<Response> addMedicine(Medicine medicine) async {
    return await dio.post(baseUrl, data: medicine.toJson());
  }

  Future<Response> updateMedicine(Medicine medicine) async {
    return await dio.patch('$baseUrl/${medicine.id}', data: medicine.toJson());
  }

  Future<Response> deleteMedicine(String id) async {
    return await dio.delete('$baseUrl/$id');
  }

  Future<Response> searchMedicines(String query) async {
    return await dio.post('/search', data: {'medicineName': query});
  }

  Future<Response> getMedicinesByCategory(String category) async {
    return await dio.get('$baseUrl/category/$category');
  }
}
