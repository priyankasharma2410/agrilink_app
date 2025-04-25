import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CustomBottomNavBarFarmer extends StatelessWidget {
  final int currentIndex;

  CustomBottomNavBarFarmer({required this.currentIndex});

  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _handleNavigation(BuildContext context, int index) async {
    switch (index) {
      case 0:
        await _speak("Orders");
        if (ModalRoute.of(context)?.settings.name != '/profilee') {
          Navigator.pushReplacementNamed(context, '/profilee');
        }
        break;
      case 1:
        await _speak("Community");
        if (ModalRoute.of(context)?.settings.name != '/community') {
          Navigator.pushReplacementNamed(context, '/community');
        }
        break;
      case 2:
        await _speak("Farmer Profile");
        if (ModalRoute.of(context)?.settings.name != '/profile') {
          Navigator.pushReplacementNamed(context, '/profile');
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) => _handleNavigation(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
