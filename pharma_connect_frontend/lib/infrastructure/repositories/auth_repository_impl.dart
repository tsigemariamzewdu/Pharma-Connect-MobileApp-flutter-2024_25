import 'package:dartz/dartz.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';
import 'package:pharma_connect_flutter/domain/repositories/auth_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/api_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await api.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
      String email, String password, String name,
      {String? lastName, String? confirmPassword}) async {
    try {
      final user = await api.register(email, password, name,
          lastName: lastName, confirmPassword: confirmPassword);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await api.logout();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await api.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile(User user) async {
    try {
      await api.updateProfile(user);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await api.changePassword(currentPassword, newPassword);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final api = ref.watch(authApiProvider);
  return AuthRepositoryImpl(api);
});
