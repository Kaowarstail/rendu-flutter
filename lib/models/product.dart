class Product {
  final String uuid;
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    required this.uuid,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      uuid: json['id'] ?? '', // L'API utilise 'id' au lieu de 'uuid'
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: double.parse((json['price'] ?? 0).toString()),
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
