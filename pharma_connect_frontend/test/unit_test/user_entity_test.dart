import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/domain/entities/auth/user.dart';

void main() {
  test('User value equality and fromJson/toJson', () {
    const user1 = User(
      id: '1',
      email: 'test@example.com',
      name: 'Test',
      role: 'user',
      firstName: 'Test',
      lastName: 'User',
      phone: '123456',
      address: '123 St',
      pharmacyId: 'ph1',
      token: 'token',
    );
    const user2 = User(
      id: '1',
      email: 'test@example.com',
      name: 'Test',
      role: 'user',
      firstName: 'Test',
      lastName: 'User',
      phone: '123456',
      address: '123 St',
      pharmacyId: 'ph1',
      token: 'token',
    );
    expect(user1, user2);
    final json = user1.toJson();
    final fromJson = User.fromJson(json);
    expect(fromJson, user1);
  });
}
