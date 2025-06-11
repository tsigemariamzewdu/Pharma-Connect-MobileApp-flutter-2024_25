import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';
import 'package:pharma_connect_flutter/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      await event.map(
        checkAuth: (e) => _onCheckAuth(e, emit),
        login: (e) => _onLogin(e, emit),
        register: (e) => _onRegister(e, emit),
        logout: (e) => _onLogout(e, emit),
        updateProfile: (e) => _onUpdateProfile(e, emit),
        changePassword: (e) => _onChangePassword(e, emit),
      );
    });
  }

  Future<void> _onCheckAuth(_CheckAuth event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await repository.getCurrentUser();
    result.fold(
      (failure) => emit(const AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogin(_Login event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await repository.login(event.email, event.password);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onRegister(_Register event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await repository.register(event.email, event.password, event.name);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> _onLogout(_Logout event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await repository.logout();
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  Future<void> _onUpdateProfile(_UpdateProfile event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await repository.updateProfile(event.user);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(AuthState.authenticated(event.user)),
    );
  }

  Future<void> _onChangePassword(_ChangePassword event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await repository.changePassword(event.currentPassword, event.newPassword);
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(state),
    );
  }
} 