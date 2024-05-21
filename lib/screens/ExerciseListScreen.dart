import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ExerciseDetailsScreen.dart';

class ExerciseListScreen extends StatefulWidget {
  final String bodyPartName;

  ExerciseListScreen({required this.bodyPartName});

  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late List<dynamic> exercises;
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true; // Set initial loading state
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    final url = 'https://exercisedb.p.rapidapi.com/exercises/bodyPart/${widget.bodyPartName}';
    final headers = {
      'X-RapidAPI-Key': 'aa24b6fb09msha2e0d754d3bfb53p1d02ccjsneb10ebabd44e',
      'X-RapidAPI-Host': 'exercisedb.p.rapidapi.com',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    final decodedResponse = json.decode(response.body);
    setState(() {
      exercises = decodedResponse;
      isLoading = false; // Set loading state to false after data is fetched
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bodyPartName.toUpperCase()),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            onTap: () {
              // Navigate to exercise details screen and pass the exercise ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetailsScreen(exerciseId: exercise['id']),
                ),
              );
            },
            title: Text(exercise['name']),
            subtitle: Text('Target Muscle: ${exercise['target']}'),
            leading: Image.network(
              exercise['gifUrl'],
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
