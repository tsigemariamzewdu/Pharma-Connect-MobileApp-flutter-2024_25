import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';
import 'package:pharma_connect_flutter/domain/repositories/application_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/application_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/api_client.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationApi api;
  ApplicationRepositoryImpl(this.api);

  @override
  Future<Either<Failure, void>> approveApplication(String id) async {
    try {
      await api.updateApplicationStatus(id, 'Approved');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to approve application'));
    }
  }

  @override
  Future<Either<Failure, void>> rejectApplication(String id) async {
    try {
      await api.updateApplicationStatus(id, 'Rejected');
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to reject application'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getApplications() async {
    try {
      final apps = await api.getApplications();
      return Right(apps);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch applications'));
    }
  }
}

final applicationRepositoryProvider =
    Provider<ApplicationRepositoryImpl>((ref) {
  final api = ref.watch(applicationApiProvider);
  return ApplicationRepositoryImpl(api);
});
