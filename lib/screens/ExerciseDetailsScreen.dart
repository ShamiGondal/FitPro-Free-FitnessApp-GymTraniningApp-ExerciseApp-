import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseId;

  ExerciseDetailsScreen({required this.exerciseId});

  @override
  _ExerciseDetailsScreenState createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  Map<String, dynamic> exerciseDetails = {};

  @override
  void initState() {
    super.initState();
    fetchExerciseDetails();
  }

  Future<void> fetchExerciseDetails() async {
    final url = 'https://exercisedb.p.rapidapi.com/exercises/exercise/${widget.exerciseId}';
    final headers = {
      'X-RapidAPI-Key': 'aa24b6fb09msha2e0d754d3bfb53p1d02ccjsneb10ebabd44e',
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    final decodedResponse = json.decode(response.body);
    setState(() {
      exerciseDetails = decodedResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Details'),
      ),
      body: exerciseDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the GIF
            Image.network(
              exerciseDetails['gifUrl'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Display the exercise name
            Text(
              exerciseDetails['name'].toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display the target muscle
            Text(
              'Target Muscle: ${exerciseDetails['target']}',
              style: TextStyle(fontSize: 18),
            ),
            // Display the secondary muscles
            Text(
              'Secondary Muscles: ${exerciseDetails['secondaryMuscles'].join(", ")}',
              style: TextStyle(fontSize: 18),
            ),
            // Display the instructions
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...exerciseDetails['instructions'].map<Widget>((instruction) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  instruction,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

}
