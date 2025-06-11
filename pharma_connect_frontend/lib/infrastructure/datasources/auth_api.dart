import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';

class AuthApi {
  final Dio dio;
  static const String _baseUrl = 'http://10.4.113.71:5000/api/v1';

  AuthApi(this.dio);

  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }

  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '$_baseUrl/users/signIn',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Login Response: \\n${response.data}'); // Debug log
      print('Response Headers: ${response.headers}'); // Debug log

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final authHeader = response.headers.value('authorization');
        String? token;
        if (authHeader != null && authHeader.startsWith('Bearer ')) {
          token = authHeader.substring(7); // Remove 'Bearer ' prefix
          setAuthToken(token);
        }

        print('Parsed user role: \\n[32m${userData['role']}[0m'); // Debug log

        // Create a basic user from login response
        final user = User(
          id: userData['userId']?.toString() ?? '',
          email: email,
          name: (userData['name'] ?? userData['firstName'] ?? '').toString(),
          firstName: userData['firstName']?.toString() ?? '',
          lastName: userData['lastName']?.toString() ?? '',
          role: userData['role']?.toString() ?? 'user',
          pharmacyId: userData['pharmacyId']?.toString(),
          token: token,
        );
        return user;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}'); // Debug log
      print('Response: ${e.response?.data}'); // Debug log
      _handleError(e);
      rethrow;
    } catch (e) {
      print('Unexpected error: $e'); // Debug log
      rethrow;
    }
  }

  Future<User> register(String email, String password, String firstName,
      {String? lastName, String? confirmPassword}) async {
    try {
      final response = await dio.post(
        '$_baseUrl/users/signUp',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          if (lastName != null) 'lastName': lastName,
          if (confirmPassword != null) 'confirmPassword': confirmPassword,
        },
      );

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        final authHeader = response.headers.value('authorization');
        String? token;
        if (authHeader != null && authHeader.startsWith('Bearer ')) {
          token = authHeader.substring(7); // Remove 'Bearer ' prefix
          setAuthToken(token);
        }

        final user = User(
          id: userData['userId']?.toString() ?? '',
          email: email,
          name: (userData['name'] ?? firstName ?? '').toString(),
          firstName: userData['firstName']?.toString() ?? '',
          lastName: userData['lastName']?.toString() ?? '',
          role: userData['role']?.toString() ?? 'user',
          pharmacyId: userData['pharmacyId']?.toString(),
          token: token,
        );
        return user;
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<void> logout() async {
    clearAuthToken();
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await dio.get('$_baseUrl/users/profile');

      if (response.data['success'] == true) {
        final userData = response.data['data'];
        return User(
          id: userData['userId'],
          email: userData['email'],
          name: userData['name'],
          role: userData['role'],
          phone: userData['phone'],
          address: userData['address'],
        );
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to get user profile');
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<void> updateProfile(User user) async {
    try {
      final response = await dio.put(
        '$_baseUrl/users/profile',
        data: {
          'name': user.name,
          'phone': user.phone,
          'address': user.address,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final response = await dio.put(
        '$_baseUrl/users/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(
            response.data['message'] ?? 'Failed to change password');
      }
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    if (e.response?.statusCode == 401) {
      clearAuthToken();
    }
    throw Exception(e.response?.data['message'] ?? e.message);
  }
}
