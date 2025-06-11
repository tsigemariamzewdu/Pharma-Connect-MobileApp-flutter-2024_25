import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/domain/repositories/medicine_repository.dart';

part 'medicine_state.dart';

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineRepository repository;

  MedicineCubit(this.repository) : super(MedicineInitial());

  Future<void> fetchMedicines() async {
    emit(MedicineLoading());
    final result = await repository.getMedicines();
    result.fold(
      (failure) => emit(MedicineError(failure.message)),
      (medicines) => emit(MedicineLoaded(medicines)),
    );
  }

  Future<void> addMedicine(Medicine medicine) async {
    final result = await repository.addMedicine(medicine);
    result.fold(
      (failure) => emit(MedicineError(failure.message)),
      (_) => fetchMedicines(),
    );
  }

  Future<void> updateMedicine(String id, Medicine medicine) async {
    final result = await repository.updateMedicine(medicine);
    result.fold(
      (failure) => emit(MedicineError(failure.message)),
      (_) => fetchMedicines(),
    );
  }

  Future<void> deleteMedicine(String id) async {
    final result = await repository.deleteMedicine(id);
    result.fold(
      (failure) => emit(MedicineError(failure.message)),
      (_) => fetchMedicines(),
    );
  }
}
