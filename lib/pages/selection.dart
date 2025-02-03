import 'package:flutter/material.dart';
import 'farmer_profile.dart'; // Import farmer profile page
import 'consumer_profile.dart'; // Import consumer profile page

class SelectionPage extends StatelessWidget {
  const SelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FarmerProfile()));
              },
              child: const Text('Farmer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConsumerProfile()));
              },
              child: const Text('Consumer'),
            ),
          ],
        ),
      ),
    );
  }
}
