import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<String> cropNames = ['Soyabean', 'Safflower', 'Sugarcane', 'Jute', 'Moong', 'Groundnut', 'Sunflower'];
  List<double> cropPrices = [];
  late Timer _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    cropPrices = List.generate(cropNames.length, (_) => _generateRandomPrice());
    _timer = Timer.periodic(Duration(seconds: 4), (_) => _updatePrices());
  }

  double _generateRandomPrice() => 1800 + _random.nextDouble() * 2500;
  void _updatePrices() => setState(() {
        cropPrices = List.generate(cropNames.length, (_) => _generateRandomPrice());
      });

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/farmerOrders');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profilee');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.green,
        title: Row(children: [Icon(Icons.eco, color: Colors.green[800]), SizedBox(width: 8), Text('AgriLink', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Gainers', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: cropNames.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(cropNames[index], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Price (per Qtl.): ₹${cropPrices[index].toStringAsFixed(2)}'),
                    //trailing: Icon(Icons.trending_up, color: Colors.green),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Star Commodity Prediction', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Sunflower: ₹${cropPrices[6].toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Jute: ₹${cropPrices[3].toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Farmer Profile"),
        ],
      ),
    );
  }
}
