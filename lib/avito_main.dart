import 'features/account/presentation/screens/account_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'features/vendors/presentation/screens/vendors_screen.dart';
import 'features/selling/presentation/screens/selling_screen.dart';
import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'shared/models/product_model.dart';

class CartItem {
  final AvitoItem product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice {
    // Extract numeric value from price string (e.g., "₽85,000" -> 85000)
    String priceStr = product.price.replaceAll(RegExp(r'[^\d]'), '');
    double price = double.tryParse(priceStr) ?? 0.0;
    return price * quantity;
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    this.isRead = false,
  });
}

class AvitoMain extends StatefulWidget {
  @override
  _AvitoMainState createState() => _AvitoMainState();
}

class _AvitoMainState extends State<AvitoMain> {

  int _currentIndex = 0;
  
  // Cart state management
  List<CartItem> _cartItems = [];
  
  // Notification state management
  List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New message from John',
      message: 'Hi! I\'m interested in your iPhone...',
      time: '2 min ago',
      icon: Icons.message,
      color: Colors.blue,
    ),
    NotificationItem(
      id: '2',
      title: 'Your ad was promoted',
      message: 'Your iPhone ad is now featured!',
      time: '1 hour ago',
      icon: Icons.star,
      color: Colors.orange,
    ),
    NotificationItem(
      id: '3',
      title: 'New follower',
      message: 'Sarah started following you',
      time: '3 hours ago',
      icon: Icons.person_add,
      color: Colors.green,
    ),
  ];

  int get unreadNotificationsCount {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  int get cartItemCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  double get cartTotalAmount {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
  }

  // Cart methods
  void addToCart(AvitoItem product) {
    setState(() {
      final existingItemIndex = _cartItems.indexWhere((item) => item.product.title == product.title);
      
      if (existingItemIndex != -1) {
        // Item already exists, don't add again
        return;
      } else {
        // Add new item
        _cartItems.add(CartItem(product: product));
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.title} added to cart'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void removeFromCart(String productTitle) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.title == productTitle);
    });
  }

  void updateCartItemQuantity(String productTitle, int newQuantity) {
    setState(() {
      final itemIndex = _cartItems.indexWhere((item) => item.product.title == productTitle);
      if (itemIndex != -1) {
        if (newQuantity <= 0) {
          _cartItems.removeAt(itemIndex);
        } else {
          _cartItems[itemIndex].quantity = newQuantity;
        }
      }
    });
  }

  void clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
        List<Widget> _screens = [
      HomeScreen(
        onAddToCart: addToCart,
        onRemoveFromCart: removeFromCart,
      ),
      AccountScreen(),
      SellingScreen(),
      ChatScreen(),
      VendorsScreen(),
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: kAccentColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.shopping_bag, color: kAccentColor, size: 22),
              ),
            ),
            SizedBox(width: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Zare',
                    style: TextStyle(
                      color: kAccentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'Shop',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Cart icon
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart_outlined, color: kTextPrimaryColor),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: kAccentColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        cartItemCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _showCartDialog();
            },
          ),
          // Notifications icon
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: kTextPrimaryColor),
                if (unreadNotificationsCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        unreadNotificationsCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _showNotificationsDialog();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Container(
            height: 0.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      ),
      floatingActionButton: null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kAccentColor,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            label: 'Sell',
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kAccentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
            activeIcon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kAccentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Chat',
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
          ),
          BottomNavigationBarItem(
            label: 'Vendors',
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
          ),
        ],
      ),
      body: _screens[_currentIndex],
    );
  }

  void _showCartDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title and total
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  if (_cartItems.isNotEmpty)
                    Text(
                      '₽${cartTotalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kAccentColor,
                      ),
                    ),
                ],
              ),
            ),
            // Cart items
            Flexible(
              child: _cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 64,
                            color: kIconsColor,
                          ),
                          
                          SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontSize: 16,
                              color: kTextSecondaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add some products to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: kTextSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      children: _cartItems.map((cartItem) => 
                        _buildCartItem(cartItem)
                      ).toList(),
                    ),
            ),
            // Checkout button
            if (_cartItems.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              clearCart();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cart cleared'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Clear Cart',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Proceeding to checkout...'),
                                  backgroundColor: kAccentColor,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kAccentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'Checkout',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem cartItem) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              cartItem.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: kBackgroundColor,
                  child: Icon(Icons.image, color: kIconsColor),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.product.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  cartItem.product.price,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kAccentColor,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      updateCartItemQuantity(cartItem.product.title, cartItem.quantity - 1);
                    },
                    icon: Icon(Icons.remove, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      minimumSize: Size(24, 24),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    cartItem.quantity.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      updateCartItemQuantity(cartItem.product.title, cartItem.quantity + 1);
                    },
                    icon: Icon(Icons.add, size: 16),
                    style: IconButton.styleFrom(
                      backgroundColor: kAccentColor,
                      minimumSize: Size(24, 24),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                '₽${cartItem.totalPrice.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kTextSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kTextPrimaryColor,
                    ),
                  ),
                  if (unreadNotificationsCount > 0)
                    TextButton(
                      onPressed: () {
                        // Mark all as read functionality removes the notification badge and also clears the notification log
                        _markAllAsRead();
                        Navigator.pop(context); // Close the dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Notifications marked as read'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text(
                        'Mark all as read',
                        style: TextStyle(color: kAccentColor),
                      ),
                    ),
                ],
              ),
            ),
            // Notifications list
            Flexible(
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: kIconsColor,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No notifications',
                            style: TextStyle(
                              fontSize: 16,
                              color: kTextSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      children: _notifications.map((notification) => 
                        _buildNotificationItem(notification)
                      ).toList(),
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.grey[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification.isRead ? Colors.grey[200]! : Colors.blue[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(notification.icon, color: notification.color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                          color: kTextPrimaryColor,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: kTextSecondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  notification.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: kTextSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
