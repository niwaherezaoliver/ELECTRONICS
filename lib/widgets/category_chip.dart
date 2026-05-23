import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.blue.shade200,
            width: 1,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: Colors.blue.shade800,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
