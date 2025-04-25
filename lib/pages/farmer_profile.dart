import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FarmerProfile extends StatefulWidget {
  @override
  _FarmerProfileState createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isTtsEnabled = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _speakOrderDetails();
  }

  Future<void> _speakOrderDetails() async {
    if (_isTtsEnabled) {
      String orderText = "You have new orders. Nishi Poojari ordered 6kg for ₹256.50, quoted at ₹230 from Mysuru. "
          "Shipped order: Sudheer A, 3kg for ₹128 from Bengaluru. No pending orders.";
      await flutterTts.speak(orderText);
    }
  }

  Future<void> _stopTts() async => await flutterTts.stop();

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);

    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/community');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/profilee');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        actions: [
          IconButton(icon: Icon(Icons.refresh, color: Colors.white), onPressed: _speakOrderDetails),
          IconButton(
            icon: Icon(_isTtsEnabled ? Icons.volume_up : Icons.volume_off, color: Colors.white),
            onPressed: () {
              setState(() => _isTtsEnabled = !_isTtsEnabled);
              if (!_isTtsEnabled) _stopTts();
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        currentIndex: 0,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Farmer Profile"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.green[100],
      padding: const EdgeInsets.all(16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("New Orders", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _buildOrderTile("Nishi Poojari", "6kg", "₹256.50", "₹230", "Mysuru"),
        SizedBox(height: 20),
        Text("Shipped", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _buildOrderTile("Sudheer A", "3kg", "₹128", null, "Bengaluru"),
        SizedBox(height: 20),
        Text("Pending", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text("No orders pending 😊", style: TextStyle(fontSize: 16)),
      ]),
    );
  }

  Widget _buildOrderTile(String name, String qty, String price, String? quotedPrice, String place) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.green[300], child: Icon(Icons.person, color: Colors.white)),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Qt: $qty"),
            Text("Price: $price"),
            if (quotedPrice != null) Text("Customer Quoting: $quotedPrice"),
            Text("Place: $place"),
          ],
        ),
        trailing: Icon(Icons.chat_bubble_outline, color: Colors.green),
      ),
    );
  }
}
