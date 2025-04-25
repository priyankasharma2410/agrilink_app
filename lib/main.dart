import 'package:agrilink_app/pages/farmer_profile.dart';
import 'package:agrilink_app/pages/farmer_profilepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider for state management
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/community_page.dart';
import 'firebase_options.dart';

import 'pages/login_page.dart';
import 'pages/consumer_profile.dart';
import 'pages/product_details_screen.dart';
import 'pages/cart_screen.dart';
import 'pages/profile_screen.dart'; // ✅ Import the Profile Screen
import 'pages/farmer_profilepage.dart'; 
import 'pages/postpage.dart';

import 'models/cart_model.dart'; // Ensure CartModel is imported
import 'pages/chackout_page.dart'; // ✅ Import Checkout Page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString('languageCode');

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(), // Provide CartModel for state management
      child: MyApp(initialLanguageCode: langCode),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? initialLanguageCode;

  const MyApp({super.key, this.initialLanguageCode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    if (widget.initialLanguageCode != null) {
      _locale = Locale(widget.initialLanguageCode!);
    }
  }

  void setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriLink Customer',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      initialRoute: '/login', // ✅ Set initial route
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => ConsumerProfile(),
        '/productDetails': (context) => ProductDetailsScreen(),
        '/cart': (context) => CartScreen(),
        '/profilee': (context) => FarmerProfilePage(),
        '/profile': (context) => ProfileScreen(), // ✅ Add Profile Route
        '/checkout': (context) => ChackoutPage(), // ✅ Add Checkout Route
        '/post': (context) => PostPage(),
        '/community': (context) => CommunityPage(),
        '/farmerOrders': (context) => FarmerProfile(), 
      },
    );
  }
}