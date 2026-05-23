import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  final fs.FirebaseFirestore _firestore = fs.FirebaseFirestore.instance;
  
  List<Order> _orders = [];
  List<Order> _userOrders = [];
  Order? _selectedOrder;
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  List<Order> get userOrders => _userOrders;
  Order? get selectedOrder => _selectedOrder;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllOrders() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      fs.QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      _orders = snapshot.docs
          .map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserOrders(String userId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      fs.QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _userOrders = snapshot.docs
          .map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<Order?> getOrderById(String orderId) async {
    try {
      fs.DocumentSnapshot doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        _selectedOrder = Order.fromMap(doc.data() as Map<String, dynamic>);
        notifyListeners();
        return _selectedOrder;
      }
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<String?> createOrder({
    required String userId,
    required List<OrderItem> items,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
    String? deliveryNotes,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      OrderDelivery delivery = OrderDelivery(
        status: 'pending',
        estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
        updates: [
          DeliveryUpdate(
            timestamp: DateTime.now(),
            status: 'order_placed',
            description: 'Order has been placed successfully',
          ),
        ],
      );

      Order newOrder = Order(
        id: '',
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        shippingAddress: shippingAddress,
        paymentMethod: paymentMethod,
        createdAt: DateTime.now(),
        deliveryNotes: deliveryNotes,
        delivery: delivery,
      );

      fs.DocumentReference docRef = await _firestore.collection('orders').add(newOrder.toMap());
      
      Order orderWithId = newOrder.copyWith(id: docRef.id);
      await docRef.update(orderWithId.toMap());

      await _firestore.collection('users').doc(userId).update({
        'orderHistory': fs.FieldValue.arrayUnion([docRef.id])
      });

      _userOrders.insert(0, orderWithId);
      notifyListeners();
      
      return docRef.id;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status, {
    String? deliveryPerson,
    String? deliveryPersonPhone,
    String? description,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      fs.DocumentReference orderRef = _firestore.collection('orders').doc(orderId);
      fs.DocumentSnapshot doc = await orderRef.get();
      
      if (!doc.exists) return false;

      Order order = Order.fromMap(doc.data() as Map<String, dynamic>);
      
      OrderDelivery updatedDelivery = order.delivery;
      if (deliveryPerson != null) {
        updatedDelivery = OrderDelivery(
          status: status,
          deliveryPerson: deliveryPerson,
          deliveryPersonPhone: deliveryPersonPhone,
          estimatedDelivery: order.delivery.estimatedDelivery,
          updates: [
            ...order.delivery.updates,
            DeliveryUpdate(
              timestamp: DateTime.now(),
              status: status,
              description: description ?? 'Order status updated to $status',
            ),
          ],
        );
      } else {
        updatedDelivery = OrderDelivery(
          status: status,
          deliveryPerson: order.delivery.deliveryPerson,
          deliveryPersonPhone: order.delivery.deliveryPersonPhone,
          estimatedDelivery: order.delivery.estimatedDelivery,
          updates: [
            ...order.delivery.updates,
            DeliveryUpdate(
              timestamp: DateTime.now(),
              status: status,
              description: description ?? 'Order status updated to $status',
            ),
          ],
        );
      }

      Order updatedOrder = order.copyWith(
        status: status,
        delivery: updatedDelivery,
        deliveredAt: status == 'delivered' ? DateTime.now() : order.deliveredAt,
      );

      await orderRef.update(updatedOrder.toMap());

      int index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = updatedOrder;
      }

      index = _userOrders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _userOrders[index] = updatedOrder;
      }

      if (_selectedOrder?.id == orderId) {
        _selectedOrder = updatedOrder;
      }

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

  Future<bool> assignDeliveryPerson(String orderId, String deliveryPerson, String deliveryPersonPhone) async {
    return await updateOrderStatus(
      orderId,
      'out_for_delivery',
      deliveryPerson: deliveryPerson,
      deliveryPersonPhone: deliveryPersonPhone,
      description: 'Order assigned to delivery person: $deliveryPerson',
    );
  }

  Future<bool> cancelOrder(String orderId, String reason) async {
    return await updateOrderStatus(
      orderId,
      'cancelled',
      description: 'Order cancelled: $reason',
    );
  }

  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  double getTotalRevenue() {
    return _orders
        .where((order) => order.status == 'delivered')
        .fold(0, (total, item) => total + item.totalAmount);
  }

  Map<String, int> getOrderStats() {
    Map<String, int> stats = {
      'pending': 0,
      'confirmed': 0,
      'preparing': 0,
      'out_for_delivery': 0,
      'delivered': 0,
      'cancelled': 0,
    };

    for (Order order in _orders) {
      stats[order.status] = (stats[order.status] ?? 0) + 1;
    }

    return stats;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelectedOrder() {
    _selectedOrder = null;
    notifyListeners();
  }
}
