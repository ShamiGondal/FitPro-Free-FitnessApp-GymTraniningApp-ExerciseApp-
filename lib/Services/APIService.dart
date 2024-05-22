import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String bodyPartUrl = 'https://exercisedb.p.rapidapi.com/exercises/bodyPartList';
  static const Map<String, String> headers = {
    'X-RapidAPI-Key': '5ac9ce656emsh71cff86de6e1ccep15acbfjsne645560d12b8',
    'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
  };

  static Future<List<String>> fetchBodyParts() async {
    final response = await http.get(Uri.parse(bodyPartUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Failed to load body parts');
    }
  }
}
