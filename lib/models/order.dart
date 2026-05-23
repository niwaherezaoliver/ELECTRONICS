class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final String? trackingNumber;
  final String? deliveryNotes;
  final OrderDelivery delivery;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
    required this.createdAt,
    this.deliveredAt,
    this.trackingNumber,
    this.deliveryNotes,
    required this.delivery,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      shippingAddress: map['shippingAddress'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      deliveredAt: map['deliveredAt']?.toDate(),
      trackingNumber: map['trackingNumber'],
      deliveryNotes: map['deliveryNotes'],
      delivery: OrderDelivery.fromMap(map['delivery'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'deliveredAt': deliveredAt,
      'trackingNumber': trackingNumber,
      'deliveryNotes': deliveryNotes,
      'delivery': delivery.toMap(),
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      productImage: map['productImage'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
    };
  }
}

class OrderDelivery {
  final String status;
  final String? deliveryPerson;
  final String? deliveryPersonPhone;
  final DateTime? estimatedDelivery;
  final List<DeliveryUpdate> updates;

  OrderDelivery({
    required this.status,
    this.deliveryPerson,
    this.deliveryPersonPhone,
    this.estimatedDelivery,
    required this.updates,
  });

  factory OrderDelivery.fromMap(Map<String, dynamic> map) {
    return OrderDelivery(
      status: map['status'] ?? 'pending',
      deliveryPerson: map['deliveryPerson'],
      deliveryPersonPhone: map['deliveryPersonPhone'],
      estimatedDelivery: map['estimatedDelivery']?.toDate(),
      updates: (map['updates'] as List<dynamic>?)
          ?.map((update) => DeliveryUpdate.fromMap(update))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'deliveryPerson': deliveryPerson,
      'deliveryPersonPhone': deliveryPersonPhone,
      'estimatedDelivery': estimatedDelivery,
      'updates': updates.map((update) => update.toMap()).toList(),
    };
  }
}

class DeliveryUpdate {
  final DateTime timestamp;
  final String status;
  final String? description;

  DeliveryUpdate({
    required this.timestamp,
    required this.status,
    this.description,
  });

  factory DeliveryUpdate.fromMap(Map<String, dynamic> map) {
    return DeliveryUpdate(
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
      status: map['status'] ?? '',
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'status': status,
      'description': description,
    };
  }
}

// Extension method for Order copyWith
extension OrderCopyWith on Order {
  Order copyWith({
    String? id,
    String? userId,
    List<OrderItem>? items,
    double? totalAmount,
    String? status,
    String? shippingAddress,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? deliveredAt,
    String? trackingNumber,
    String? deliveryNotes,
    OrderDelivery? delivery,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      delivery: delivery ?? this.delivery,
    );
  }
}
