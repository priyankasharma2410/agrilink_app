import 'package:flutter/material.dart';

void main() {
  runApp(FarmerProfile());
}

class FarmerProfile extends StatefulWidget {
  @override
  _FarmerProfileState createState() => _FarmerProfileState();
}

class _FarmerProfileState extends State<FarmerProfile> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    FarmerProfilePage(),
    FarmerOrdersPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Orders'),
          ],
        ),
      ),
    );
  }
}

class FarmerProfilePage extends StatefulWidget {
  @override
  _FarmerProfilePageState createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  List<Map<String, String>> farmers = [
    {'name': 'Raju', 'crop': 'Fruits'},
    {'name': 'Venkatesh', 'crop': 'Vegetables'},
  ];

  void _addFarmer(String name, String crop) {
    setState(() {
      farmers.add({'name': name, 'crop': crop});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Farmer Profile')),
      body: ListView.builder(
        itemCount: farmers.length,
        itemBuilder: (context, index) {
          final farmer = farmers[index];
          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.black,
            child: ListTile(
              title: Text(farmer['name']!, style: TextStyle(color: Colors.white, fontSize: 18)),
              subtitle: Text(farmer['crop']!, style: TextStyle(color: Colors.white70)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddFarmerPage(onSubmit: _addFarmer)),
        ),
      ),
    );
  }
}

class AddFarmerPage extends StatefulWidget {
  final Function(String, String) onSubmit;
  AddFarmerPage({required this.onSubmit});

  @override
  _AddFarmerPageState createState() => _AddFarmerPageState();
}

class _AddFarmerPageState extends State<AddFarmerPage> {
  final _nameController = TextEditingController();
  final _cropController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Farmer')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Farmer Name')),
            TextField(controller: _cropController, decoration: InputDecoration(labelText: 'Crop Type')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  _nameController.text,
                  _cropController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Add Farmer'),
            ),
          ],
        ),
      ),
    );
  }
}

class FarmerOrdersPage extends StatefulWidget {
  @override
  _FarmerOrdersPageState createState() => _FarmerOrdersPageState();
}

class _FarmerOrdersPageState extends State<FarmerOrdersPage> {
  List<Map<String, String>> orders = [
    {'name': 'Sonu', 'product': 'Apple', 'date': '11/12/24', 'status': 'Confirmed'},
    {'name': 'Raj', 'product': 'Sugarcane', 'date': '11/09/24', 'status': 'Pending'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${order['name']}', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Product: ${order['product']}', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Date: ${order['date']}', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text('Status: ${order['status']}', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
