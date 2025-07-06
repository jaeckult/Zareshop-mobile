import 'features/account/presentation/screens/account_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'features/vendors/presentation/screens/vendors_screen.dart';
import 'features/selling/presentation/screens/selling_screen.dart';
import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';

class AvitoMain extends StatefulWidget {
  @override
  _AvitoMainState createState() => _AvitoMainState();
}

class _AvitoMainState extends State<AvitoMain> {

  int _currentIndex = 0;

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      HomeScreen(),
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
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined, color: kTextPrimaryColor),
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
                      '3',
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
                  TextButton(
                    onPressed: () {
                      // Mark all as read functionality
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
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationItem(
                    'New message from John',
                    'Hi! I\'m interested in your iPhone...',
                    '2 min ago',
                    Icons.message,
                    Colors.blue,
                  ),
                  _buildNotificationItem(
                    'Your ad was promoted',
                    'Your iPhone ad is now featured!',
                    '1 hour ago',
                    Icons.star,
                    Colors.orange,
                  ),
                  _buildNotificationItem(
                    'New follower',
                    'Sarah started following you',
                    '3 hours ago',
                    Icons.person_add,
                    Colors.green,
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

  Widget _buildNotificationItem(String title, String message, String time, IconData icon, Color color) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimaryColor,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: kTextSecondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  time,
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
