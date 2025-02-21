import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(
              context, '/home'); // ✅ Marketplace goes to Home
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/cart');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/profile'); // ✅ Profile Page
        }
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.store), label: "Marketplace"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
