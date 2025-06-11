import 'package:dio/dio.dart';

class ApplicationApi {
  final Dio dio;
  final String baseUrl;

  ApplicationApi({required this.dio, this.baseUrl = '/applications'});

  Future<void> updateApplicationStatus(String id, String status) async {
    await dio.patch('$baseUrl/$id/status', data: {'status': status});
  }

  Future<List<Map<String, dynamic>>> getApplications() async {
    final response = await dio.get(baseUrl);
    final data = response.data['applications'] as List;
    return List<Map<String, dynamic>>.from(data);
  }
}
