import 'package:flutter/material.dart';

class WorkoutProgressScreen extends StatelessWidget {
  final List<int> completedExercisesCount;
  final List<int> totalExercises;

  WorkoutProgressScreen({required this.completedExercisesCount, required this.totalExercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Progress'),
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final int completed = completedExercisesCount[index];
          final int total = totalExercises[index];
          final double percentage = (completed / total) * 100;

          return ListTile(
            title: Text('Day ${index + 1}'),
            subtitle: Text('Completed: $completed / $total exercises'),
            trailing: Text('${percentage.toStringAsFixed(0)}%'),
          );
        },
      ),
    );
  }
}
