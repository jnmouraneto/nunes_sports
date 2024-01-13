import 'dart:convert';

class Product {
  late String id;
  late String name;
  late String description;
  late double price;

  Product(
      {required this.name,
      required this.description,
      required this.price,
      this.id = ''});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
    );
  }

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
    };
  }
}
