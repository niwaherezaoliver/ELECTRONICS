class AppUser {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profileImage;
  final List<String> addresses;
  final DateTime createdAt;
  final bool isAdmin;
  final List<String> orderHistory;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImage,
    required this.addresses,
    required this.createdAt,
    this.isAdmin = false,
    required this.orderHistory,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'],
      addresses: List<String>.from(map['addresses'] ?? []),
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      isAdmin: map['isAdmin'] ?? false,
      orderHistory: List<String>.from(map['orderHistory'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImage': profileImage,
      'addresses': addresses,
      'createdAt': createdAt,
      'isAdmin': isAdmin,
      'orderHistory': orderHistory,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    List<String>? addresses,
    DateTime? createdAt,
    bool? isAdmin,
    List<String>? orderHistory,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      isAdmin: isAdmin ?? this.isAdmin,
      orderHistory: orderHistory ?? this.orderHistory,
    );
  }
}
