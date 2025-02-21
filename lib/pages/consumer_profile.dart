import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import SpeechToText
import '../widgets/bottom_nav_bar.dart'; // Ensure this file exists

class ConsumerProfile extends StatefulWidget {
  @override
  _ConsumerProfileState createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  Position? _currentPosition;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "Tap mic & speak a command...";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _speech = stt.SpeechToText();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
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
          _performAction(_command);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _performAction(String command) {
    command = command.toLowerCase();

    for (var product in products) {
      if (command.contains(product["name"].toLowerCase())) {
        Navigator.pushNamed(
          context,
          '/productDetails',
          arguments: product,
        );
        return; // Exit the function once a product is matched and navigated
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No matching product found!")),
    );
  }

  final List<Map<String, dynamic>> products = [
    {
      "name": "Roma Tomatoes",
      "price": "₹50/kg",
      "image": "assets/tomato.jpg",
    },
    {
      "name": "Golden Potatoes",
      "price": "₹30/kg",
      "image": "assets/potato.jpg",
    },
    {
      "name": "Organic Wheat",
      "price": "₹40/kg",
      "image": "assets/wheat.jpg",
    },
    {
      "name": "Carrots",
      "price": "₹60/kg",
      "image": "assets/carrot.jpg",
    },
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
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
