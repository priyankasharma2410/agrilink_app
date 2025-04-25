import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getCropRecommendation(List<double> features) async {
  final url = Uri.parse('http://your-local-or-live-ip:5000/predict');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'features': features}),
  );

  final data = jsonDecode(response.body);
  return data['prediction'];
}
