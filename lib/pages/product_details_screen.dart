import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../widgets/bottom_nav_bar.dart';

class ProductDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Safely get product arguments
    final Map<String, dynamic>? product = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Details')),
        body: Center(child: Text('Product details not available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(product["name"] ?? "Product Name")),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0), // Fixed NavBar
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product["name"] ?? "Item"} added to cart')),
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