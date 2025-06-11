import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';

class MedicineApi {
  final Dio dio;
  static const String _baseUrl = '/medicines';

  MedicineApi(this.dio);

  Future<List<Medicine>> getAll() async {
    final response = await dio.get(_baseUrl);
    final List data = response.data['data'];
    return data.map((json) => Medicine.fromJson(json)).toList();
  }

  Future<Medicine> add(Medicine medicine) async {
    final response = await dio.post(_baseUrl, data: medicine.toJson());
    return Medicine.fromJson(response.data['data']);
  }

  Future<Medicine> update(String id, Medicine medicine) async {
    final response = await dio.put('$_baseUrl/$id', data: medicine.toJson());
    return Medicine.fromJson(response.data['data']);
  }

  Future<void> delete(String id) async {
    await dio.delete('$_baseUrl/$id');
  }
}
