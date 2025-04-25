import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';  // Import Text-to-Speech package
import 'package:speech_to_text/speech_to_text.dart' as stt; // For speech-to-text
import '../models/cart_model.dart';
import '../widgets/bottom_nav_bar.dart';

class ChackoutPage extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts(); // Initialize TTS
  final stt.SpeechToText _speech = stt.SpeechToText(); // Initialize Speech Recognition

  // Function to speak the order confirmation
  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  // Function to listen for voice command
  void _listenAndPlaceOrder(BuildContext context, double totalPrice) async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(
        onResult: (result) async {
          String command = result.recognizedWords.toLowerCase();
          if (command.contains("place order")) {
            String message = "Your order has been successfully placed.";
            await _speak(message);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Order Placed!'),
                content: Text(message),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Provider.of<CartModel>(context, listen: false).clearCart();
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.of(context).pop(); // Go back
                    },
                  ),
                ],
              ),
            );

            _speech.stop();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartModel>(context).cartItems;

    // Calculate total price dynamically by extracting numeric values
    double totalPrice = cartItems.fold(0, (sum, item) {
      String priceString = item['price']?.toString() ?? '0';
      double price = double.tryParse(priceString.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      return sum + price;
    });

    return Scaffold(
      appBar: AppBar(title: Text("Checkout")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Summary', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  String priceString = item['price']?.toString() ?? '0';
                  return ListTile(
                    leading: Image.asset(item['image'], width: 50, height: 50),
                    title: Text(item['name'] ?? ''),
                    subtitle: Text('Price: $priceString'),
                  );
                },
              ),
            ),
            Divider(),
            Text('Total: ₹${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            // Mic Button placed just above the "Place Order" button
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.mic, color: Colors.green, size: 30),
                onPressed: () => _listenAndPlaceOrder(context, totalPrice),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                String message = "Your order has been successfully placed.";
                _speak(message); // Speak the order confirmation

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Order Placed!'),
                    content: Text(message),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Provider.of<CartModel>(context, listen: false).clearCart();
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(); // Go back
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Center(
                child: Text('Place Order', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
