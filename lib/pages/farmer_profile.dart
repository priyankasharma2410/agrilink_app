import 'package:flutter/material.dart';

void main() {
  runApp(FarmerProfileApp());
}

class FarmerProfileApp extends StatefulWidget {
  @override
  _FarmerProfileAppState createState() => _FarmerProfileAppState();
}

class _FarmerProfileAppState extends State<FarmerProfileApp> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    FarmerProfile(),
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

class FarmerProfile extends StatelessWidget {
  const FarmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Profile')),
      body: const Center(child: Text('Welcome, Farmer!')),
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

  void _addOrder(String name, String product, String date, String status) {
    setState(() {
      orders.add({'name': name, 'product': product, 'date': date, 'status': status});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: () {}),
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddOrderPage(onSubmit: _addOrder)),
        ),
      ),
    );
  }
}

class AddOrderPage extends StatefulWidget {
  final Function(String, String, String, String) onSubmit;
  AddOrderPage({required this.onSubmit});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final _nameController = TextEditingController();
  final _productController = TextEditingController();
  final _dateController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Order')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Farmer Name')),
            TextField(controller: _productController, decoration: InputDecoration(labelText: 'Product')),
            TextField(controller: _dateController, decoration: InputDecoration(labelText: 'Date')),
            TextField(controller: _statusController, decoration: InputDecoration(labelText: 'Status')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  _nameController.text,
                  _productController.text,
                  _dateController.text,
                  _statusController.text,
                );
                Navigator.pop(context);
              },
              child: Text('Add Order'),
            ),
          ],
        ),
      ),
    );
  }
}
