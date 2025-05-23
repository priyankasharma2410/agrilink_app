import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import Text-to-Speech package
import '../models/cart_model.dart';
import '../widgets/bottom_nav_bar.dart';

class CartScreen extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts(); // Initialize TTS

  // Function to speak text
  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartModel>(context).cartItems;

    return Scaffold(
      appBar: AppBar(title: Text("Shopping Cart")),
      body: cartItems.isEmpty
          ? Center(
              child: Text("Your cart is empty"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(product['image'], width: 50, height: 50),
                          title: Text(product['name'] ?? ''),
                          subtitle: Text(product['price'] != null ? "${product['price']}" : ''), // Fixed price display
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              Provider.of<CartModel>(context, listen: false).removeItem(product);
                              _speak("${product['name']} removed from cart");
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ₹${Provider.of<CartModel>(context).totalPrice.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _speak("Proceeding to checkout");
                          Navigator.of(context).pushNamed('/checkout'); // Navigate to checkout page
                        },
                        child: Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
