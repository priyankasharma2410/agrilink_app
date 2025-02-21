import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../widgets/bottom_nav_bar.dart';

class ChackoutPage extends StatelessWidget {  // Fixed the typo in class name
  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartModel>(context).cartItems;

    // Calculate total price dynamically by extracting numeric values
    double totalPrice = cartItems.fold(0, (sum, item) {
      String priceString = item['price']?.toString() ?? '0';
      // Extract numeric value from price string
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
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Order Placed!'),
                    content: Text('Your order has been successfully placed.'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Provider.of<CartModel>(context, listen: false).clearCart();
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(context).pop(); // Go back to the cart or home
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
