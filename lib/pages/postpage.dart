import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final FlutterTts flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  File? _imageFile;
  TextEditingController _cropController = TextEditingController();
  TextEditingController _descController = TextEditingController();
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
    _speak(_getLocalizedText('intro'));
  }

  String _getLocalizedText(String key) {
    Map<String, Map<String, String>> translations = {
      'intro': {
        'en-US': "You are on the Post Page. Enter crop name, description, and upload an image.",
        'hi-IN': "आप पोस्ट पेज पर हैं। फसल का नाम, विवरण दर्ज करें और एक छवि अपलोड करें।",
        'kn-IN': "ನೀವು ಪೋಸ್ಟ್ ಪುಟದಲ್ಲಿ ಇದ್ದೀರಿ. ಬೆಳೆ ಹೆಸರನ್ನು, ವಿವರಣೆಯನ್ನು ನಮೂದಿಸಿ ಮತ್ತು ಚಿತ್ರವನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ.",
        'ta-IN': "நீங்கள் இடுகை பக்கத்தில் உள்ளீர்கள். பயிர் பெயர், விளக்கம் உள்ளிடவும் மற்றும் ஒரு படத்தை பதிவேற்றவும்.",
      },
      'upload_success': {
        'en-US': "Image uploaded successfully.",
        'hi-IN': "छवि सफलतापूर्वक अपलोड की गई।",
        'kn-IN': "ಚಿತ್ರವನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಅಪ್‌ಲೋಡ್ ಮಾಡಲಾಗಿದೆ.",
        'ta-IN': "படம் வெற்றிகரமாக பதிவேற்றப்பட்டது.",
      },
      'submit_success': {
        'en-US': "Post submitted successfully.",
        'hi-IN': "पोस्ट सफलतापूर्वक सबमिट की गई।",
        'kn-IN': "ಪೋಸ್ಟ್ ಯಶಸ್ವಿಯಾಗಿ ಸಲ್ಲಿಸಲಾಗಿದೆ.",
        'ta-IN': "இடுகை வெற்றிகரமாக சமர்ப்பிக்கப்பட்டது.",
      },
      'fill_all': {
        'en-US': "Please fill in all details before submitting.",
        'hi-IN': "कृपया सबमिट करने से पहले सभी विवरण भरें।",
        'kn-IN': "ದಾಖಲಿಸುವ ಮೊದಲು ದಯವಿಟ್ಟು ಎಲ್ಲಾ ವಿವರಗಳನ್ನು ಭರ್ತಿ ಮಾಡಿ.",
        'ta-IN': "சமர்ப்பிக்கும் முன் அனைத்து விபரங்களையும் நிரப்பவும்.",
      },
    };

    return translations[key]?[_selectedLanguage] ?? "";
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage(_selectedLanguage);
    await flutterTts.speak(text);
  }

  void _startListening(TextEditingController controller) async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() {
          controller.text = result.recognizedWords;
        });
      });
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _speak(_getLocalizedText('upload_success'));
    }
  }

  void _submitPost() {
    if (_cropController.text.isNotEmpty && _descController.text.isNotEmpty) {
      Navigator.pop(context, {
        "crop": _cropController.text,
        "description": _descController.text,
        "image": _imageFile,
      });
      _speak(_getLocalizedText('submit_success'));
    } else {
      _speak(_getLocalizedText('fill_all'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        backgroundColor: Colors.green,
        actions: [
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
          IconButton(
            icon: Icon(Icons.volume_up, color: Colors.white),
            onPressed: () => _speak(_getLocalizedText('intro')),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cropController,
              decoration: InputDecoration(
                labelText: "Enter crop name",
                filled: true,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () => _startListening(_cropController),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Description",
                filled: true,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () => _startListening(_descController),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text("Upload Image"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _submitPost,
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
