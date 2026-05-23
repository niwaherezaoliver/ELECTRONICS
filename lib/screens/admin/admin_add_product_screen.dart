import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class AdminAddProductScreen extends StatefulWidget {
  final Product? product;

  const AdminAddProductScreen({super.key, this.product});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _brandController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _featureController = TextEditingController();

  String _selectedCategory = 'Smartphones';
  List<String> _features = [];
  bool _isActive = true;

  final List<String> _categories = [
    'Smartphones',
    'Laptops',
    'Tablets',
    'Smart Watches',
    'Headphones',
    'Cameras',
    'Gaming',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _loadProductData();
    }
  }

  void _loadProductData() {
    final product = widget.product!;
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _priceController.text = product.price.toString();
    _stockController.text = product.stock.toString();
    _brandController.text = product.brand;
    _imageUrlController.text = product.imageUrl;
    _selectedCategory = product.category;
    _features = List.from(product.features);
    _isActive = product.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _imageUrlController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    Product product = Product(
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text.trim(),
      category: _selectedCategory,
      stock: int.parse(_stockController.text),
      features: _features,
      rating: widget.product?.rating ?? 0.0,
      reviewCount: widget.product?.reviewCount ?? 0,
      brand: _brandController.text.trim(),
      createdAt: widget.product?.createdAt ?? DateTime.now(),
      isActive: _isActive,
    );

    bool success;
    if (widget.product == null) {
      success = await productProvider.addProduct(product);
    } else {
      success = await productProvider.updateProduct(product);
    }

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.product == null
                ? 'Product added successfully'
                : 'Product updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _addFeature() {
    if (_featureController.text.trim().isNotEmpty) {
      setState(() {
        _features.add(_featureController.text.trim());
        _featureController.clear();
      });
    }
  }

  void _removeFeature(int index) {
    setState(() {
      _features.removeAt(index);
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageUrlController.text = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveProduct,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                _nameController,
                'Product Name',
                'Enter product name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _brandController,
                'Brand',
                'Enter brand name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter brand name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _priceController,
                'Price',
                'Enter price',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _stockController,
                'Stock',
                'Enter stock quantity',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter stock quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _descriptionController,
                'Description',
                'Enter product description',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildImageSection(),
              const SizedBox(height: 16),
              _buildFeaturesSection(),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active'),
                subtitle: const Text('Product will be visible to customers'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _pickImage, child: const Text('Browse')),
          ],
        ),
        if (_imageUrlController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                _imageUrlController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _featureController,
                decoration: InputDecoration(
                  labelText: 'Add feature',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                onFieldSubmitted: (_) => _addFeature(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(onPressed: _addFeature, icon: const Icon(Icons.add)),
          ],
        ),
        if (_features.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _features.asMap().entries.map((entry) {
              int index = entry.key;
              String feature = entry.value;
              return Chip(
                label: Text(feature),
                onDeleted: () => _removeFeature(index),
                deleteIcon: const Icon(Icons.close, size: 16),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
