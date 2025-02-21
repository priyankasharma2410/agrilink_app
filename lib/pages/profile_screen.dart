import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "Tap mic & speak...";
  String _activeField = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("Status: $status"),
        onError: (error) => print("Error: $error"),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _command = result.recognizedWords;
          });
          _handleSpeechInput(_command);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _handleSpeechInput(String command) {
    command = command.toLowerCase();

    if (command.contains("name")) {
      _activeField = "name";
    } else if (command.contains("phone")) {
      _activeField = "phone";
    } else if (command.contains("username")) {
      _activeField = "username";
    } else if (command.contains("password")) {
      _activeField = "password";
    } else if (command.contains("state")) {
      _activeField = "state";
    }

    if (_activeField.isNotEmpty) {
      _fillField(_activeField, command);
    }
  }

  void _fillField(String field, String value) {
    switch (field) {
      case "name":
        nameController.text = value.replaceFirst("name", "").trim();
        break;
      case "phone":
        phoneController.text = value.replaceFirst("phone", "").trim();
        break;
      case "username":
        usernameController.text = value.replaceFirst("username", "").trim();
        break;
      case "password":
        passwordController.text = value.replaceFirst("password", "").trim();
        break;
      case "state":
        stateController.text = value.replaceFirst("state", "").trim();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            TextField(
              controller: stateController,
              decoration: InputDecoration(labelText: "State"),
            ),
            SizedBox(height: 20),
            Text("🎙 Command: $_command",
                style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Profile Saved!")));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Save Profile"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        backgroundColor: Colors.green,
        child: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.white),
      ),
    );
  }
}
