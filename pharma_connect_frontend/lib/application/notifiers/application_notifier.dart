import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/application_repository_impl.dart';
import 'package:pharma_connect_flutter/core/errors/failures.dart';

// Move this model to a shared location if not already
class Application {
  final String id;
  final String name;
  final String owner;
  final String contact;
  final String email;
  final String status;

  Application({
    required this.id,
    required this.name,
    required this.owner,
    required this.contact,
    required this.email,
    required this.status,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['_id'] as String,
      name: json['pharmacyName'] as String,
      owner: json['ownerName'] as String,
      contact: json['contactNumber'] as String,
      email: json['email'] as String,
      status: json['status'] as String,
    );
  }
}

class ApplicationNotifier extends StateNotifier<AsyncValue<List<Application>>> {
  final ApplicationRepositoryImpl repository;
  ApplicationNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadApplications();
  }

  Future<void> loadApplications() async {
    state = const AsyncValue.loading();
    final result = await repository.getApplications();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (apps) => state =
          AsyncValue.data(apps.map((e) => Application.fromJson(e)).toList()),
    );
  }

  Future<void> approveApplication(String id) async {
    final result = await repository.approveApplication(id);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => loadApplications(),
    );
  }

  Future<void> rejectApplication(String id) async {
    final result = await repository.rejectApplication(id);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => loadApplications(),
    );
  }
}

final applicationProvider =
    StateNotifierProvider<ApplicationNotifier, AsyncValue<List<Application>>>(
        (ref) {
  final repository = ref.watch(applicationRepositoryProvider);
  return ApplicationNotifier(repository);
});
