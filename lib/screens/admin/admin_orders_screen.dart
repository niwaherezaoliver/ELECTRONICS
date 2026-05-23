import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).loadAllOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Confirmed'),
            Tab(text: 'Preparing'),
            Tab(text: 'Delivery'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (orderProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading orders',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    orderProvider.errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      orderProvider.loadAllOrders();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrdersList(orderProvider.orders),
              _buildOrdersList(orderProvider.getOrdersByStatus('pending')),
              _buildOrdersList(orderProvider.getOrdersByStatus('confirmed')),
              _buildOrdersList(orderProvider.getOrdersByStatus('preparing')),
              _buildOrdersList(orderProvider.getOrdersByStatus('out_for_delivery')),
              _buildOrdersList([
                ...orderProvider.getOrdersByStatus('delivered'),
                ...orderProvider.getOrdersByStatus('cancelled'),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.receipt_long,
            color: Colors.blue.shade600,
          ),
        ),
        title: Text('Order #${order.id.substring(0, 8)}'),
        subtitle: Text('Placed on ${_formatDate(order.createdAt)}'),
        trailing: _buildStatusChip(order.status),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderDetails(order),
                const SizedBox(height: 16),
                _buildOrderItems(order),
                const SizedBox(height: 16),
                _buildActionButtons(order),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Amount',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '\$${order.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            Text(_formatPaymentMethod(order.paymentMethod)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shipping Address',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                order.shippingAddress,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        if (order.deliveryNotes != null) ...[
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Notes',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  order.deliveryNotes!,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOrderItems(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        ...order.items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.image, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Qty: ${item.quantity}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildActionButtons(Order order) {
    switch (order.status) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _updateOrderStatus(order.id, 'confirmed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Confirm'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showCancelDialog(order),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Cancel'),
              ),
            ),
          ],
        );
      case 'confirmed':
        return ElevatedButton(
          onPressed: () => _updateOrderStatus(order.id, 'preparing'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: const Text('Start Preparing'),
        );
      case 'preparing':
        return ElevatedButton(
          onPressed: () => _showDeliveryDialog(order),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Out for Delivery'),
        );
      case 'out_for_delivery':
        return ElevatedButton(
          onPressed: () => _updateOrderStatus(order.id, 'delivered'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text('Mark as Delivered'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status) {
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        displayText = 'Pending';
        break;
      case 'confirmed':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        displayText = 'Confirmed';
        break;
      case 'preparing':
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        displayText = 'Preparing';
        break;
      case 'out_for_delivery':
        backgroundColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade800;
        displayText = 'Out for Delivery';
        break;
      case 'delivered':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        displayText = 'Delivered';
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        displayText = 'Cancelled';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade800;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    bool success = await orderProvider.updateOrderStatus(orderId, status);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to $status'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showCancelDialog(Order order) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please enter a reason for cancellation:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              await orderProvider.cancelOrder(order.id, reasonController.text);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order cancelled'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }

  void _showDeliveryDialog(Order order) {
    final personController = TextEditingController();
    final phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Delivery Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: personController,
              decoration: const InputDecoration(
                labelText: 'Delivery Person Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final orderProvider = Provider.of<OrderProvider>(context, listen: false);
              await orderProvider.assignDeliveryPerson(
                order.id,
                personController.text,
                phoneController.text,
              );
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order assigned for delivery'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Assign'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatPaymentMethod(String method) {
    switch (method) {
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      case 'card':
        return 'Credit/Debit Card';
      default:
        return method;
    }
  }
}
