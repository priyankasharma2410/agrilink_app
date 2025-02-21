import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider for state management
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'pages/login_page.dart';
import 'pages/consumer_profile.dart';
import 'pages/product_details_screen.dart';
import 'pages/cart_screen.dart';
import 'pages/profile_screen.dart'; // ✅ Import the Profile Screen
import 'models/cart_model.dart'; // Ensure CartModel is imported
import 'pages/chackout_page.dart'; // ✅ Import Checkout Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(), // Provide CartModel for state management
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriLink Customer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // ✅ Set initial route
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => ConsumerProfile(),
        '/productDetails': (context) => ProductDetailsScreen(),
        '/cart': (context) => CartScreen(),
        '/profile': (context) => ProfileScreen(), // ✅ Add Profile Route
        '/checkout': (context) => ChackoutPage(), // ✅ Add Checkout Route
      },
    );
  }
}
