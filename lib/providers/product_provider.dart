import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Product> _products = [
    Product(
      id: '1',
      name: 'iPhone 15 Pro',
      brand: 'Apple',
      category: 'Smartphones',
      description: 'The latest iPhone with A17 Pro chip, titanium design, and advanced camera system.',
      price: 999.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 15,
      rating: 4.8,
      reviewCount: 245,
      features: ['A17 Pro Chip', '48MP Camera', 'Titanium Design', '5G Support'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Samsung Galaxy S24 Ultra',
      brand: 'Samsung',
      category: 'Smartphones',
      description: 'Premium Android smartphone with S Pen, advanced camera system, and AI features.',
      price: 1199.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 12,
      rating: 4.6,
      reviewCount: 189,
      features: ['S Pen', '200MP Camera', 'AI Features', '5000mAh Battery'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: 'MacBook Air M2',
      brand: 'Apple',
      category: 'Laptops',
      description: 'Ultra-thin laptop with M2 chip, all-day battery life, and stunning Retina display.',
      price: 1299.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 8,
      rating: 4.7,
      reviewCount: 156,
      features: ['M2 Chip', '18-hour Battery', 'Retina Display', 'MagSafe Charging'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '4',
      name: 'Dell XPS 15',
      brand: 'Dell',
      category: 'Laptops',
      description: 'High-performance laptop with Intel Core i7, NVIDIA graphics, and InfinityEdge display.',
      price: 1499.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 6,
      rating: 4.4,
      reviewCount: 98,
      features: ['Intel Core i7', 'NVIDIA RTX 4050', 'InfinityEdge Display', '32GB RAM'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '5',
      name: 'AirPods Pro 2',
      brand: 'Apple',
      category: 'Audio',
      description: 'Premium wireless earbuds with active noise cancellation and spatial audio.',
      price: 249.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 25,
      rating: 4.5,
      reviewCount: 312,
      features: ['Active Noise Cancellation', 'Spatial Audio', '6-hour Battery', 'MagSafe Charging'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '6',
      name: 'Sony WH-1000XM5',
      brand: 'Sony',
      category: 'Audio',
      description: 'Industry-leading noise canceling headphones with exceptional sound quality.',
      price: 399.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 18,
      rating: 4.7,
      reviewCount: 267,
      features: ['Industry-leading ANC', '30-hour Battery', 'Multipoint Connection', 'LDAC Support'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '7',
      name: 'iPad Pro 12.9"',
      brand: 'Apple',
      category: 'Tablets',
      description: 'The most powerful iPad with M2 chip and stunning Liquid Retina XDR display.',
      price: 1099.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 10,
      rating: 4.8,
      reviewCount: 203,
      features: ['M2 Chip', 'Liquid Retina XDR', 'ProMotion', '5G Support'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '8',
      name: 'Samsung Galaxy Tab S9 Ultra',
      brand: 'Samsung',
      category: 'Tablets',
      description: 'Premium Android tablet with S Pen and stunning AMOLED display.',
      price: 899.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 14,
      rating: 4.5,
      reviewCount: 178,
      features: ['S Pen', 'Dynamic AMOLED 2X', '120Hz Display', 'Quad Speakers'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '9',
      name: 'Apple Watch Series 9',
      brand: 'Apple',
      category: 'Wearables',
      description: 'Advanced health and fitness tracking with bright Always-On Retina display.',
      price: 399.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 20,
      rating: 4.6,
      reviewCount: 289,
      features: ['Always-On Display', 'Advanced Health Sensors', 'Water Resistant', '18-hour Battery'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '10',
      name: 'Samsung Galaxy Watch 6',
      brand: 'Samsung',
      category: 'Wearables',
      description: 'Comprehensive health and fitness tracking with vibrant AMOLED display.',
      price: 299.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 22,
      rating: 4.4,
      reviewCount: 167,
      features: ['Body Composition Analysis', 'Sleep Tracking', 'Advanced Workout Detection', 'IP68 Water Resistant'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '11',
      name: 'PlayStation 5',
      brand: 'Sony',
      category: 'Gaming',
      description: 'Next-generation gaming console with ultra-fast SSD and immersive gaming.',
      price: 499.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 5,
      rating: 4.7,
      reviewCount: 445,
      features: ['4K Gaming', 'Ultra-fast SSD', 'Haptic Feedback', '3D Audio'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '12',
      name: 'Xbox Series X',
      brand: 'Microsoft',
      category: 'Gaming',
      description: 'Most powerful Xbox ever with 12 teraflops of processing power.',
      price: 449.99,
      imageUrl: 'https://via.placeholder.com/300x300',
      stock: 8,
      rating: 4.5,
      reviewCount: 389,
      features: ['12 Teraflops', 'Quick Resume', 'Smart Delivery', 'Xbox Game Pass'],
      createdAt: DateTime.now(),
    ),
  ];
  List<Product> _featuredProducts = [];
  List<Product> _productsByCategory = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _categories = [];

  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get productsByCategory => _productsByCategory;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get categories => _categories;

  Future<void> loadProducts() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      _products = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      _featuredProducts = _products.where((product) => product.rating >= 4.0).take(10).toList();
      
      _extractCategories();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();

      _productsByCategory = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        _selectedProduct = Product.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
        return _selectedProduct;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .get();

      List<Product> allProducts = snapshot.docs
          .map((doc) => Product.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               product.description.toLowerCase().contains(query.toLowerCase()) ||
               product.brand.toLowerCase().contains(query.toLowerCase()) ||
               product.category.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }

  Future<bool> addProduct(Product product) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      DocumentReference docRef = await _firestore.collection('products').add(product.toMap());
      
      Product newProduct = product.copyWith(id: docRef.id);
      await docRef.update(newProduct.toMap());
      
      _products.insert(0, newProduct);
      _extractCategories();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProduct(Product product) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _firestore.collection('products').doc(product.id).update(product.toMap());
      
      int index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }
      
      if (_selectedProduct?.id == product.id) {
        _selectedProduct = product;
      }
      
      _extractCategories();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteProduct(String productId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _firestore.collection('products').doc(productId).update({'isActive': false});
      
      _products.removeWhere((p) => p.id == productId);
      _featuredProducts.removeWhere((p) => p.id == productId);
      
      if (_selectedProduct?.id == productId) {
        _selectedProduct = null;
      }
      
      _extractCategories();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _extractCategories() {
    Set<String> categorySet = _products.map((p) => p.category).toSet();
    _categories = categorySet.toList();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}
