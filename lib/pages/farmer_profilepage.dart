import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FarmerProfilePage extends StatefulWidget {
  @override
  _FarmerProfilePageState createState() => _FarmerProfilePageState();
}

class _FarmerProfilePageState extends State<FarmerProfilePage> {
  final FlutterTts flutterTts = FlutterTts();
  List<Map<String, dynamic>> _posts = [];
  String _selectedLanguage = 'en-US';

  final Map<String, String> _languageMap = {
    'English': 'en-US',
    'Hindi': 'hi-IN',
    'Kannada': 'kn-IN',
    'Tamil': 'ta-IN',
  };

  @override
  void initState() {
    super.initState();
    _speak("You are on the Farmer Profile Page. Tap on the plus button to add a new post.");
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(_selectedLanguage);
    await flutterTts.speak(text);
  }

  void _addNewPost(String crop, String description, File? imageFile) {
    setState(() {
      _posts.add({"crop": crop, "description": description, "image": imageFile});
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/farmerOrders');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/community');
    }
  }

  String _getLocalizedProfileText() {
    switch (_selectedLanguage) {
      case 'hi-IN':
        return "राजू एम की प्रोफ़ाइल। वह गन्ना उगाते हैं। आपके पास ${_posts.length} पोस्ट हैं।";
      case 'kn-IN':
        return "ರಾಜು ಎಮ್ ಅವರ ಪ್ರೊಫೈಲ್. ಅವರು ಶರಕಾರಿ ಬೆಳೆದಿದ್ದಾರೆ. ನಿಮ್ಮ ಬಳಿ ${_posts.length} ಪೋಸ್ಟ್ಗಳು ಇವೆ.";
      case 'ta-IN':
        return "ராஜு எம் அவர்களின் சுயவிவரம். அவர் கரும்பு வளர்க்கிறார். உங்களிடம் ${_posts.length} இடுகைகள் உள்ளன.";
      default:
        return "Profile of Raju M. He grows Sugarcane. You have ${_posts.length} posts.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: [
            Text("Farmer Profile", style: TextStyle(color: Colors.white)),
            Spacer(),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _languageMap.entries.firstWhere((e) => e.value == _selectedLanguage).key,
                dropdownColor: Colors.white,
                style: TextStyle(color: Colors.black),
                icon: Icon(Icons.language, color: Colors.white),
                onChanged: (String? newLang) {
                  if (newLang != null) {
                    setState(() {
                      _selectedLanguage = _languageMap[newLang]!;
                    });
                    _speak("Language changed to $newLang");
                  }
                },
                items: _languageMap.keys.map((String lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(lang),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.white),
            onPressed: () => _speak(_getLocalizedProfileText()),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/selection', (route) => false);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error logging out: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: AssetImage('assets/Farmer.jpg')),
              SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Raju M", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[800])),
                Text("grows Sugarcane", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ]),
            ],
          ),
          SizedBox(height: 20),
          Text("Posts", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[800])),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                var post = _posts[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: post["image"] != null
                              ? Image.file(post["image"], width: 80, height: 80, fit: BoxFit.cover)
                              : Icon(Icons.image, size: 80, color: Colors.grey),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post["crop"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900])),
                              Text(post["description"], style: TextStyle(color: Colors.grey[800])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          var result = await Navigator.pushNamed(context, '/post');
          if (result is Map<String, dynamic>) {
            _addNewPost(result["crop"], result["description"], result["image"]);
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Community"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
