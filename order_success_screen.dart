import 'package:flutter/material.dart';
import '../user/home_screen.dart';
import '../user/orders_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Thank you for your order. Your order has been placed and will be delivered soon.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Order ID',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      orderId,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const OrdersScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Track Order',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
