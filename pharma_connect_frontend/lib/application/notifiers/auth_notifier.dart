import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/auth_repository_impl.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/local/session_manager.dart';

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepositoryImpl repository;
  final Ref ref;
  AuthNotifier(this.repository, this.ref) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await repository.login(email, password);
    await result.fold(
      (failure) async =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) async {
        // Save pharmacyId to session if present
        final sessionManager = ref.read(sessionManagerProvider);
        if (user.pharmacyId != null && user.pharmacyId!.isNotEmpty) {
          await sessionManager.savePharmacyId(user.pharmacyId);
        }
        await sessionManager.saveUserId(user.id);
        state = AsyncValue.data(user);
      },
    );
  }

  Future<void> register(String email, String password, String name,
      {String? lastName, String? confirmPassword}) async {
    state = const AsyncValue.loading();
    final result = await repository.register(email, password, name,
        lastName: lastName, confirmPassword: confirmPassword);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> logout() async {
    final sessionManager = ref.read(sessionManagerProvider);
    await sessionManager.clearSession();
    state = const AsyncValue.data(null);
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();
    final result = await repository.getCurrentUser();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository, ref);
});
