import 'screens/acccount_screen.dart';
import 'screens/announces_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/selling__screen.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

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
      AnnouncesScreen(),
      AccountScreen(),
      SellingScreen(),
      ChatScreen(),
      NotificationsScreen(),
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
            Text(
              'ZareShop',
              style: TextStyle(
                color: kAccentColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
          ],
        ),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     color: kAppBarIconColor,
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.favorite_border),
        //     color: kAppBarIconColor,
        //     onPressed: () {},
        //   ),
        // ],
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
            label: 'Notifications',
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: _screens[_currentIndex],
    );
  }
}
