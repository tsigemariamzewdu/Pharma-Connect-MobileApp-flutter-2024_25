class Medicine {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'category': category,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Medicine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class MedicineSearchResult {
  final String pharmacyName;
  final String address;
  final String photo;
  final double price;
  final int quantity;
  final double latitude;
  final double longitude;
  final String pharmacyId;
  final String inventoryId;

  MedicineSearchResult({
    required this.pharmacyName,
    required this.address,
    required this.photo,
    required this.price,
    required this.quantity,
    required this.latitude,
    required this.longitude,
    required this.pharmacyId,
    required this.inventoryId,
  });

  factory MedicineSearchResult.fromJson(Map<String, dynamic> json) {
    return MedicineSearchResult(
      pharmacyName: json['pharmacyName'] ?? '',
      address: json['address'] ?? '',
      photo: json['photo'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      pharmacyId: json['pharmacyId'] ?? '',
      inventoryId: json['inventoryId'] ?? '',
    );
  }
}
