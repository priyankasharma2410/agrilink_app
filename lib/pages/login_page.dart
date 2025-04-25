import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agrilink_app/pages/selection.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    // ✅ Automatically navigate after 5 seconds
    Timer(Duration(seconds: 5), () {
      _navigateToSelectionPage();
    });
  }

  void _navigateToSelectionPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToSelectionPage, // ✅ Navigate on tap
      child: Scaffold(
        backgroundColor: Color(0xFFCDE0AB), // ✅ Background color similar to your image
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ AgriLink Logo
              Image.asset('assets/agrilink_logo.png', height: 120), // Make sure this image is in assets

              SizedBox(height: 20),

              // ✅ Welcome Text
              Text(
                'Welcome to',
                style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
              ),

              Text(
                'AgriLink',
                style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
