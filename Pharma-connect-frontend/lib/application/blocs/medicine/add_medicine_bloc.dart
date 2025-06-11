import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';
import 'package:pharma_connect_flutter/domain/repositories/medicine_repository.dart';

part 'add_medicine_event.dart';
part 'add_medicine_state.dart';
part 'add_medicine_bloc.freezed.dart';

class AddMedicineBloc extends Bloc<AddMedicineEvent, AddMedicineState> {
  final MedicineRepository repository;

  AddMedicineBloc(this.repository) : super(const AddMedicineState.initial()) {
    on<AddMedicineEvent>((event, emit) async {
      await event.map(
        submitted: (e) => _onSubmitted(e, emit),
      );
    });
  }

  Future<void> _onSubmitted(_Submitted event, Emitter<AddMedicineState> emit) async {
    emit(const AddMedicineState.loading());
    
    final result = await repository.addMedicine(event.medicine);
    
    result.fold(
      (failure) => emit(AddMedicineState.error(failure.message)),
      (medicine) => emit(const AddMedicineState.success()),
    );
  }
} 