import 'package:dartz/dartz.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';

abstract class ApplicationRepository {
  Future<Either<Failure, void>> approveApplication(String id);
  Future<Either<Failure, void>> rejectApplication(String id);
  Future<Either<Failure, List<Map<String, dynamic>>>> getApplications();
}
