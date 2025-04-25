import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/cart_model.dart';
import '../widgets/bottom_nav_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late FlutterTts _flutterTts;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastCommand = '';
  String _selectedLanguage = "en"; // Default Language: English

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _speech = stt.SpeechToText();
  }

  // Change the language for TTS
  Future<void> _changeLanguage(String language) async {
    setState(() {
      _selectedLanguage = language;
    });
    await _flutterTts.setLanguage(language);
  }

  // Speak in the selected language
  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(_selectedLanguage);
    await _flutterTts.speak(text);
  }

  // Get translated text for adding to cart
  String _getAddedToCartMessage(String productName) {
    Map<String, String> translations = {
      "en": "$productName added to cart.",
      "hi": "$productName जोड़ा गया।",
      "kn": "$productName ಸೇರಿಸಲಾಗಿದೆ.",
      "ta": "$productName சேர்க்கப்பட்டது."
    };
    return translations[_selectedLanguage] ?? translations["en"]!;
  }

  // Listen for voice command to add to cart
  void _listenForCommand(Map<String, dynamic> product) async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _lastCommand = result.recognizedWords.toLowerCase();
          });

          if (_lastCommand.contains("add") && _lastCommand.contains("cart")) {
            Provider.of<CartModel>(context, listen: false).addItem(product);
            String message = _getAddedToCartMessage(product["name"] ?? "Item");
            _speak(message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            _speech.stop();
            setState(() => _isListening = false);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? product =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Details')),
        body: Center(child: Text('Product details not available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product["name"] ?? "Product Name")),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_isListening) {
            _listenForCommand(product);
          } else {
            _speech.stop();
            setState(() => _isListening = false);
          }
        },
        child: Icon(_isListening ? Icons.mic_off : Icons.mic),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selector Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Language:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  items: [
                    DropdownMenuItem(value: "en", child: Text("English")),
                    DropdownMenuItem(value: "hi", child: Text("हिन्दी (Hindi)")),
                    DropdownMenuItem(value: "kn", child: Text("ಕನ್ನಡ (Kannada)")),
                    DropdownMenuItem(value: "ta", child: Text("தமிழ் (Tamil)")),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _changeLanguage(value);
                    }
                  },
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                product["image"] ?? "assets/images/placeholder.png",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              product["name"] ?? "Unknown Product",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Farmer: ${product["farmer"] ?? "N/A"}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            Text(
              "Grown in: ${product["location"] ?? "Unknown"}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
            ),
            Text(
              "Estimated Delivery: ${product["deliveryTime"] ?? "N/A"}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              "Price: ${product["price"] ?? "0"}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<CartModel>(context, listen: false).addItem(product);
                  String message = _getAddedToCartMessage(product["name"] ?? "Item");
                  _speak(message);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                },
                icon: Icon(Icons.shopping_cart),
                label: Text("Add to Cart"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
