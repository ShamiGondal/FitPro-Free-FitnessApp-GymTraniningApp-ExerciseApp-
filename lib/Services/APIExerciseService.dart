// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const Map<String, String> _headers = {
    'X-RapidAPI-Key': 'aa24b6fb09msha2e0d754d3bfb53p1d02ccjsneb10ebabd44e',
    'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com'
  };

  static Future<List<Map<String, dynamic>>> fetchExercises() async {
    final response = await http.get(Uri.parse('$_baseUrl/exercises'), headers: _headers);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
