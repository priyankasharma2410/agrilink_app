import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

import 'farmer_profile.dart';
import 'consumer_profile.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _command = "";

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    requestMicPermission();
  }

  Future<void> requestMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech Status: $status'),
        onError: (error) => print('Speech Error: $error'),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            final recognizedText = result.recognizedWords.toLowerCase();

            _speech.stop();
            setState(() => _isListening = false);

            if (recognizedText.contains("farmer")) {
              _speak("Navigating to Farmer Profile");
              _showFarmerLoginSheet();
            } else if (recognizedText.contains("consumer")) {
              _speak("Navigating to Consumer Profile");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConsumerProfile()),
              );
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _showFarmerLoginSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Farmer Login",
                    style: TextStyle(color: Colors.white, fontSize: 22)),
                const SizedBox(height: 20),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixText: '+91 ',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _validateFarmerLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text("Login",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _validateFarmerLogin() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.length != 10 || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid phone and password")),
      );
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('farmers')
          .doc(phone)
          .get();

      print("Fetched Data: ${doc.data()}");

      final dbPassword = doc.data()?['password']?.toString().trim();

      if (doc.exists && dbPassword == password) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FarmerProfile()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
      }
    } catch (e, stackTrace) {
      print("Login Error: $e\n$stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error occurred while logging in.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSelectionOption(
                    'assets/ffarmer.jpg', 'FARMER', _showFarmerLoginSheet),
                _buildSelectionOption(
                    'assets/customer.png',
                    'CUSTOMER',
                    () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConsumerProfile()),
                        )),
              ],
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: _listen,
              child: const Icon(
                Icons.mic,
                color: Colors.white,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionOption(
      String imagePath, String text, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _speak("Selected $text");
            onTap();
          },
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Image.asset(imagePath, height: 80),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
