import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'farmer_profile.dart'; // Import farmer profile page
import 'consumer_profile.dart'; // Import consumer profile page

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Speech Status: $status'),
        onError: (error) => print('Speech Error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _command = result.recognizedWords;
            if (_command.toLowerCase().contains("farmer")) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerProfile()));
            } else if (_command.toLowerCase().contains("consumer")) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ConsumerProfile()));
            }
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerProfile()));
                  },
                  child: const Text('Farmer'),
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: _listen,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConsumerProfile()));
                  },
                  child: const Text('Consumer'),
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: _listen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}