import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/presentation/pages/auth/login_page.dart';
import 'package:pharma_connect_flutter/application/notifiers/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharma_connect_flutter/infrastructure/repositories/auth_repository_impl.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';
import 'package:pharma_connect_flutter/infrastructure/datasources/auth_api.dart';
import 'package:dio/dio.dart';

class FakeAuthApi extends AuthApi {
  FakeAuthApi() : super(Dio());
  @override
  Future<User> login(String email, String password) async => User(
      id: '',
      email: email,
      name: '',
      role: '',
      phone: '',
      address: '',
      pharmacyId: '');
  @override
  Future<User> register(String email, String password, String name,
          {String? lastName, String? confirmPassword}) async =>
      User(
          id: '',
          email: email,
          name: name,
          role: '',
          phone: '',
          address: '',
          pharmacyId: '');
  @override
  Future<void> logout() async {}
  @override
  Future<User> getCurrentUser() async => User(
      id: '',
      email: '',
      name: '',
      role: '',
      phone: '',
      address: '',
      pharmacyId: '');
  @override
  Future<void> updateProfile(User user) async {}
  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {}
}

class FakeAuthRepository extends AuthRepositoryImpl {
  FakeAuthRepository() : super(FakeAuthApi());
}

void main() {
  testWidgets('LoginForm shows email, password fields and login button',
      (WidgetTester tester) async {
    final fakeRepository = FakeAuthRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => AuthNotifier(fakeRepository, ref)),
        ],
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) =>
                LoginForm(notifier: ref.read(authProvider.notifier)),
          ),
        ),
      ),
    );
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
