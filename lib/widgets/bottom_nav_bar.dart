import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';  // Import Text-to-Speech package

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final FlutterTts flutterTts = FlutterTts(); // Initialize TTS

  CustomBottomNavBar({required this.currentIndex});

  // Function to speak when a tab is selected
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US"); // Set language
    await flutterTts.setSpeechRate(0.5);   // Adjust speech rate
    await flutterTts.setPitch(1.0);        // Adjust pitch
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) async {
        if (index == 0) {
          await _speak("Marketplace");
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 1) {
          await _speak("Cart");
          Navigator.pushReplacementNamed(context, '/cart');
        } else if (index == 2) {
          await _speak("Profile");
          Navigator.pushReplacementNamed(context, '/profile');
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
