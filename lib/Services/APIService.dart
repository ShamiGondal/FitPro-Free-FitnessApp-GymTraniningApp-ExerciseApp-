import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String bodyPartUrl = 'https://exercisedb.p.rapidapi.com/exercises/bodyPartList';
  static const Map<String, String> headers = {
    'X-RapidAPI-Key': 'aa24b6fb09msha2e0d754d3bfb53p1d02ccjsneb10ebabd44e',
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
