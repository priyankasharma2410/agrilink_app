import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For geolocation
import 'package:speech_to_text/speech_to_text.dart' as stt; // For speech recognition
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech
import '../widgets/bottom_nav_bar.dart'; // Ensure this file exists

class ConsumerProfile extends StatefulWidget {
  @override
  _ConsumerProfileState createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  Position? _currentPosition;
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  String _command = "Tap mic & speak a command...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();

    Future.delayed(Duration(seconds: 1), () {
      _speak("Welcome to AgriLink. Tap the mic and speak a product name to search.");
    });
  }

  // Get user's current location
  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  // Start listening for voice commands
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
          _performAction(_command);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // Perform action based on voice command
  void _performAction(String command) {
    command = command.toLowerCase();
    _speak("Searching for $command"); // Announce the command

    for (var product in products) {
      if (command.contains(product["name"].toLowerCase())) {
        _speak("Opening ${product['name']} details");
        Navigator.pushNamed(
          context,
          '/productDetails',
          arguments: product,
        );
        return; // Exit function if a product is matched
      }
    }

    _speak("No matching product found");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No matching product found!")),
    );
  }

  // Text-to-Speech function
  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  // Sample product data
  final List<Map<String, dynamic>> products = [
    {"name": "Roma Tomatoes", "price": "₹50/kg", "image": "assets/tomato.jpg"},
    {"name": "Golden Potatoes", "price": "₹30/kg", "image": "assets/potato.jpg"},
    {"name": "Organic Wheat", "price": "₹40/kg", "image": "assets/wheat.jpg"},
    {"name": "Carrots", "price": "₹60/kg", "image": "assets/carrot.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AgriLink - Fresh Produce"),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0), // Ensure this file exists
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome to AgriLink! 🌱",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("🗣 Voice Command: $_command",
                style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.80,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _speak("Opening ${products[index]['name']} details");
                      Navigator.pushNamed(
                        context,
                        '/productDetails',
                        arguments: products[index],
                      );
                    },
                    child: ProductCard(
                      name: products[index]["name"],
                      price: products[index]["price"],
                      imagePath: products[index]["image"],
                    ),
                  );
                },
              ),
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

// 🛒 Product Card Widget
class ProductCard extends StatelessWidget {
  final String name, price, imagePath;

  ProductCard({
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(imagePath,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(price,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
