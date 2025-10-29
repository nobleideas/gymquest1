import 'package:flutter/material.dart';
import 'package:gym_quest/model/exercise.dart';
import 'package:provider/provider.dart';
import 'view/home_view.dart';
<<<<<<< HEAD
import 'dart:io';
=======
>>>>>>> 0e51790 (save local changes before rebase)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final workoutRepo = ExerciseRepository();
  workoutRepo.addWorkout(Exercise(id: 1, name: 'Bench Press', 
  imagePath: '', pop: 'push', muscleGroup: 'chest'));

  //Process.run('python', ['app.py']);

  runApp(
    Provider<ExerciseRepository>.value(
      value: workoutRepo,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Quest',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeView(), // your starting view
    );
  }
}
