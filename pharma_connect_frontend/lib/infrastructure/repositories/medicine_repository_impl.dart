import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/domain/repositories/medicine_repository.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/remote/medicine_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/api_client.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineApi api;

  MedicineRepositoryImpl(this.api);

  @override
  Future<Either<Failure, List<Medicine>>> getMedicines() async {
    try {
      final response = await api.getMedicines();
      final List<dynamic> jsonList = response.data['data'] ?? response.data;
      final medicines =
          jsonList.map((json) => Medicine.fromJson(json)).toList();
      return Right(medicines);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch medicines'));
    }
  }

  @override
  Future<Either<Failure, Medicine>> getMedicineById(String id) async {
    try {
      final response = await api.getMedicineById(id);
      final medicine = Medicine.fromJson(response.data);
      return Right(medicine);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch medicine'));
    }
  }

  @override
  Future<Either<Failure, Medicine>> addMedicine(Medicine medicine) async {
    try {
      final response = await api.addMedicine(medicine);
      final addedMedicine = Medicine.fromJson(response.data);
      return Right(addedMedicine);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to add medicine'));
    }
  }

  @override
  Future<Either<Failure, Medicine>> updateMedicine(Medicine medicine) async {
    try {
      final response = await api.updateMedicine(medicine);
      final updatedMedicine = Medicine.fromJson(response.data);
      return Right(updatedMedicine);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update medicine'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMedicine(String id) async {
    try {
      await api.deleteMedicine(id);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete medicine'));
    }
  }

  @override
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query) async {
    try {
      final response = await api.searchMedicines(query);
      final List<dynamic> jsonList = response.data['data'] ?? [];
      final medicines =
          jsonList.map((json) => Medicine.fromJson(json)).toList();
      return Right(medicines);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to search medicines'));
    }
  }

  @override
  Future<Either<Failure, List<MedicineSearchResult>>> searchPharmacyInventory(
      String query) async {
    try {
      final response = await api.searchMedicines(query);
      final List<dynamic> jsonList = response.data['data'] ?? [];
      final results = jsonList
          .map((json) =>
              MedicineSearchResult.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(results);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to search medicines'));
    }
  }

  @override
  Future<Either<Failure, List<Medicine>>> getMedicinesByCategory(
      String category) async {
    try {
      final response = await api.getMedicinesByCategory(category);
      final List<dynamic> jsonList = response.data;
      final medicines =
          jsonList.map((json) => Medicine.fromJson(json)).toList();
      return Right(medicines);
    } on DioException catch (e) {
      return Left(
          ServerFailure(e.message ?? 'Failed to fetch medicines by category'));
    }
  }
}

final medicineRepositoryProvider = Provider<MedicineRepositoryImpl>((ref) {
  final api = ref.watch(medicineApiProvider);
  return MedicineRepositoryImpl(api);
});
