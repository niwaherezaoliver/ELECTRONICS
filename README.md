# Electronics Ordering System

A comprehensive Flutter application for electronics ordering and delivery with admin dashboard.

## Features

### User App
- **User Authentication**: Sign up, login, and profile management
- **Product Catalog**: Browse and search electronics products
- **Shopping Cart**: Add/remove items, adjust quantities
- **Order Management**: Place orders, track delivery status
- **Payment Integration**: Multiple payment methods (Cash on Delivery, Card)
- **Delivery Tracking**: Real-time order status updates
- **User Profile**: Manage personal information and addresses

### Admin Dashboard
- **Dashboard Overview**: Revenue, orders, and product statistics
- **Product Management**: Add, edit, and delete products
- **Order Management**: View and manage all orders
- **Analytics**: Sales reports and business insights
- **User Management**: View and manage customer accounts

## Technology Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **State Management**: Provider
- **Image Caching**: cached_network_image
- **UI Components**: Material Design 3

## Getting Started

### Prerequisites
- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Firebase Project

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd electronics_ordering_system
```

2. Install dependencies:
```bash
flutter pub get
```

3. Firebase Setup:
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Set up Firebase Storage
   - Download configuration files and place them in the appropriate directories

4. Update Firebase Configuration:
   - Open `lib/firebase_options.dart`
   - Replace placeholder values with your actual Firebase configuration

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── product.dart
│   ├── order.dart
│   └── user.dart
├── providers/                # State management
│   ├── auth_provider.dart
│   ├── cart_provider.dart
│   ├── product_provider.dart
│   └── order_provider.dart
├── screens/                  # UI screens
│   ├── splash_screen.dart
│   ├── auth/                # Authentication screens
│   ├── user/                # User app screens
│   └── admin/               # Admin dashboard screens
├── widgets/                  # Reusable UI components
│   ├── product_card.dart
│   ├── category_chip.dart
│   └── cart_item_card.dart
└── services/                 # API and external services
```

## Key Features Implementation

### Authentication System
- Email/password authentication
- User profile management
- Admin role differentiation
- Secure session management

### Product Management
- CRUD operations for products
- Image upload and display
- Category-based filtering
- Search functionality
- Stock management

### Order Processing
- Shopping cart functionality
- Order placement and tracking
- Delivery status updates
- Payment method selection
- Order history

### Admin Dashboard
- Real-time statistics
- Order management interface
- Product inventory management
- Analytics and reporting
- User management

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please contact the development team or create an issue in the repository.

## Future Enhancements

- [ ] Push notifications for order updates
- [ ] Advanced search and filtering
- [ ] Product reviews and ratings
- [ ] Wishlist functionality
- [ ] Discount and coupon system
- [ ] Multi-language support
- [ ] Advanced analytics dashboard
- [ ] Integration with payment gateways
- [ ] Delivery partner integration
- [ ] Real-time chat support
