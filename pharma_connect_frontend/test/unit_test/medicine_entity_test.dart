import 'package:flutter_test/flutter_test.dart';
import 'package:pharma_connect_flutter/domain/entities/medicine/medicine.dart';

void main() {
  test('Medicine fromJson and toJson', () {
    final json = {
      '_id': '1',
      'name': 'Aspirin',
      'description': 'Pain reliever',
      'image': 'img.png',
      'category': 'Analgesic',
    };
    final medicine = Medicine.fromJson(json);
    expect(medicine.id, '1');
    expect(medicine.name, 'Aspirin');
    expect(medicine.description, 'Pain reliever');
    expect(medicine.image, 'img.png');
    expect(medicine.category, 'Analgesic');
    final toJson = medicine.toJson();
    expect(toJson['name'], 'Aspirin');
    expect(toJson['description'], 'Pain reliever');
    expect(toJson['image'], 'img.png');
    expect(toJson['category'], 'Analgesic');
  });
}
