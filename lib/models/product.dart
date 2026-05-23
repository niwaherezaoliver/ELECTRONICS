class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final List<String> features;
  final double rating;
  final int reviewCount;
  final String brand;
  final DateTime createdAt;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    required this.features,
    required this.rating,
    required this.reviewCount,
    required this.brand,
    required this.createdAt,
    this.isActive = true,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      features: List<String>.from(map['features'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      brand: map['brand'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'features': features,
      'rating': rating,
      'reviewCount': reviewCount,
      'brand': brand,
      'createdAt': createdAt,
      'isActive': isActive,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    int? stock,
    List<String>? features,
    double? rating,
    int? reviewCount,
    String? brand,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      features: features ?? this.features,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      brand: brand ?? this.brand,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
