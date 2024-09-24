import 'package:flutter/material.dart';
import 'package:freshlink/views/screens/Search_screen.dart';

import 'Account_screen.dart';
import 'Cart_Screen.dart';
import 'Categories_Screen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageindex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    CategoriesScreen(),
    CartScreen(),
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            pageindex = value;
          });
        },
        currentIndex: pageindex,
        type: BottomNavigationBarType.fixed, // Ensures items are equally spaced
        items: [
          BottomNavigationBarItem(
            icon: _buildIcon('assets/icons/store.png', 0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/icons/search.png', 1),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/icons/categories.png', 2, isCategories: true), // Move this icon up
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/icons/shoppingcart.png', 3),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon('assets/icons/user.png', 4),
            label: 'Account',
          ),
        ],
        selectedItemColor: Colors.green, // Adjust the color of selected items
        unselectedItemColor: Colors.grey, // Color for unselected items
      ),
      body: _pages[pageindex],
    );
  }

  Widget _buildIcon(String assetPath, int index, {bool isCategories = false}) {
    return AnimatedPadding(
      duration: Duration(milliseconds: 200), // Animation duration
      padding: EdgeInsets.only(
        top: isCategories ? 0.0 : (pageindex == index ? 0.0 : 20), // Categories icon stays up
      ),
      child: SizedBox(
        height: 24,
        width: 24,
        child: Image.asset(assetPath),
      ),
    );
  }
}
