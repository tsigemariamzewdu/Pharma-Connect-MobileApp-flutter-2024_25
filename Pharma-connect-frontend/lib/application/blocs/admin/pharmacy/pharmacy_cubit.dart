import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pharma_connect_flutter/domain/entities/pharmacy/pharmacy.dart';
import 'package:pharma_connect_flutter/domain/repositories/pharmacy_repository.dart';

part 'pharmacy_state.dart';

class PharmacyCubit extends Cubit<PharmacyState> {
  final PharmacyRepository repository;

  PharmacyCubit(this.repository) : super(PharmacyInitial());

  Future<void> fetchPharmacies() async {
    emit(PharmacyLoading());
    try {
      final pharmacies = await repository.getPharmacies();
      emit(PharmacyLoaded(pharmacies));
    } catch (e) {
      emit(PharmacyError(e.toString()));
    }
  }

  Future<void> addPharmacy(Pharmacy pharmacy) async {
    try {
      await repository.addPharmacy(pharmacy);
      fetchPharmacies();
    } catch (e) {
      emit(PharmacyError(e.toString()));
    }
  }

  Future<void> updatePharmacy(String id, Pharmacy pharmacy) async {
    try {
      await repository.updatePharmacy(id, pharmacy.toJson());
      fetchPharmacies();
    } catch (e) {
      emit(PharmacyError(e.toString()));
    }
  }

  Future<void> deletePharmacy(String id) async {
    try {
      await repository.deletePharmacy(id);
      fetchPharmacies();
    } catch (e) {
      emit(PharmacyError(e.toString()));
    }
  }
}
