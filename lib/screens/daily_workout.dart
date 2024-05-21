import 'package:flutter/material.dart';
import 'dart:math';

import '../Services/APIExerciseService.dart';
import 'ExerciseDetailsScreen.dart';
import 'WorkoutProgressScreen.dart';

class DailyWorkout extends StatefulWidget {
  @override
  _DailyWorkoutState createState() => _DailyWorkoutState();
}

class _DailyWorkoutState extends State<DailyWorkout>
    with TickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> futureExercises;
  late List<List<Map<String, dynamic>>> weeklySchedule;
  late List<AnimationController> _animationControllers;
  late List<Animation<Offset>> _animations;
  late List<bool> workoutCompletionStatus;
  late List<int> completedExercisesCount; // Track the number of completed exercises

  @override
  void initState() {
    super.initState();
    futureExercises = ApiService.fetchExercises();
    _animationControllers = List.generate(7, (_) => AnimationController(
        vsync: this, duration: const Duration(seconds: 2)));
    _animations = _animationControllers.map((controller) =>
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut))).toList();
    workoutCompletionStatus = List.generate(7, (_) => false);
    completedExercisesCount = List.generate(7, (_) => 0); // Initialize completed exercises count
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void createWeeklySchedule(List<Map<String, dynamic>> exercises) {
    final random = Random();
    weeklySchedule = List.generate(7, (_) => []);
    for (int i = 0; i < 7; i++) {
      weeklySchedule[i] = List.generate(5, (_) => exercises[random.nextInt(exercises.length)]);
    }
  }

  void toggleWorkoutCompletion(int dayIndex) {
    setState(() {
      workoutCompletionStatus[dayIndex] = !workoutCompletionStatus[dayIndex];
      if (workoutCompletionStatus[dayIndex]) {
        completedExercisesCount[dayIndex] = weeklySchedule[dayIndex].length;
      } else {
        completedExercisesCount[dayIndex] = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Workout'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WorkoutProgressScreen(
                  completedExercisesCount: completedExercisesCount,
                  totalExercises: weeklySchedule.map((day) => day.length).toList(),
                )),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No exercises available'));
          } else {
            createWeeklySchedule(snapshot.data!);
            for (var controller in _animationControllers) {
              controller.forward();
            }
            return ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Day ${index + 1}',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: workoutCompletionStatus[index]
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.check_circle_outline),
                            onPressed: () {
                              toggleWorkoutCompletion(index);
                            },
                          ),
                        ],
                      ),
                    ),
                    ...weeklySchedule[index].map((exercise) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetailsScreen(
                              exerciseId: exercise['id'],
                            ),
                          ),
                        );
                      },
                      child: SlideTransition(
                        position: _animations[index],
                        child: Card(
                          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: Image.network(
                              exercise['gifUrl'],
                              height: 50,
                              width: 50,
                            ),
                            title: Text(
                              exercise['name'].toUpperCase(),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )).toList(),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
