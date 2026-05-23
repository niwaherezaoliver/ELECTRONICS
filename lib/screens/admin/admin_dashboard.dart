import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import 'admin_products_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_analytics_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
      Provider.of<OrderProvider>(context, listen: false).loadAllOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.signOut();
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            _buildStatsCards(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildRecentOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, ${authProvider.user?.name ?? 'Admin'}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Here\'s what\'s happening with your store today',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCards() {
    return Consumer2<ProductProvider, OrderProvider>(
      builder: (context, productProvider, orderProvider, child) {
        final stats = orderProvider.getOrderStats();
        final revenue = orderProvider.getTotalRevenue();
        final totalProducts = productProvider.products.length;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              'Total Revenue',
              '\$${revenue.toStringAsFixed(2)}',
              Icons.attach_money,
              Colors.green,
            ),
            _buildStatCard(
              'Total Orders',
              '${orderProvider.orders.length}',
              Icons.receipt_long,
              Colors.blue,
            ),
            _buildStatCard(
              'Products',
              '$totalProducts',
              Icons.inventory_2,
              Colors.orange,
            ),
            _buildStatCard(
              'Pending Orders',
              '${stats['pending'] ?? 0}',
              Icons.pending,
              Colors.red,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              'Manage Products',
              Icons.inventory,
              Colors.blue,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminProductsScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'Manage Orders',
              Icons.receipt_long,
              Colors.green,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminOrdersScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'Analytics',
              Icons.analytics,
              Colors.orange,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminAnalyticsScreen(),
                  ),
                );
              },
            ),
            _buildActionCard(
              'Users',
              Icons.people,
              Colors.purple,
              () {
                // Navigate to users management
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        final recentOrders = orderProvider.orders.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminOrdersScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(color: Colors.blue.shade600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recentOrders.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No orders yet',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...recentOrders.map((order) => _buildOrderTile(order)),
          ],
        );
      },
    );
  }

  Widget _buildOrderTile(order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
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
        subtitle: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
        trailing: _buildStatusChip(order.status),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminOrdersScreen(),
            ),
          );
        },
      ),
    );
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
}
