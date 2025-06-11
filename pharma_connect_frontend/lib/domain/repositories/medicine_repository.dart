import 'package:dartz/dartz.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';

abstract class MedicineRepository {
  Future<Either<Failure, List<Medicine>>> getMedicines();
  Future<Either<Failure, Medicine>> getMedicineById(String id);
  Future<Either<Failure, Medicine>> addMedicine(Medicine medicine);
  Future<Either<Failure, Medicine>> updateMedicine(Medicine medicine);
  Future<Either<Failure, Unit>> deleteMedicine(String id);
  Future<Either<Failure, List<Medicine>>> searchMedicines(String query);
  Future<Either<Failure, List<MedicineSearchResult>>> searchPharmacyInventory(
      String query);
  Future<Either<Failure, List<Medicine>>> getMedicinesByCategory(
      String category);
}
