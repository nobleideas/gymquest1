import 'package:flutter/material.dart';
import '../controller/workout_controller.dart';
import '../model/workout.dart';

class WorkoutView extends StatefulWidget {
  const WorkoutView({super.key});

  @override
  State<WorkoutView> createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  final WorkoutController workoutController = WorkoutController();
  late Workout currentWorkout;

  int sets = 0;
  int reps = 0;
  double weight = 5;
  int rpe = 0;

  @override
  void initState() {
    super.initState();
  }

  void _changeSets(int delta) {
    setState(() {
      sets = (sets + delta).clamp(0, 10);
    });
  }

  void _changeReps(int delta) {
    setState(() {
      reps = (reps + delta).clamp(0, 50);
    });
  }

  void _setRPE(int value) {
    setState(() {
      rpe = value;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout View'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Previous Workout (left) - read-only
                Expanded(
                  child: Container(
                    color: Colors.orange.shade100,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('Last time you did this',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 233,
                          child: Image.asset(
                            currentWorkout.imagePath,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentWorkout.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Sets: 3', style: const TextStyle(fontSize: 16)),
                        Text('Reps: 10', style: const TextStyle(fontSize: 16)),
                        Text('Weight: 170', style: const TextStyle(fontSize: 16)),
                        Text('RPE: 3', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),

                // Current Workout (right) - interactive
                Expanded(
                  child: Container(
                    color: Colors.blue.shade100,
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text('Scanned Workout',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        // Dynamic Image
                        SizedBox(
                          height: 144,
                          child: Image.asset(currentWorkout.imagePath),
                        ),
                        const SizedBox(height: 8),
                        Text(currentWorkout.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        // Sets Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _changeSets(-1),
                            ),
                            Text('Sets: $sets',
                                style: const TextStyle(fontSize: 18)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _changeSets(1),
                            ),
                          ],
                        ),

                        // Reps Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _changeReps(-1),
                            ),
                            Text('Reps: $reps',
                                style: const TextStyle(fontSize: 18)),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _changeReps(1),
                            ),
                          ],
                        ),

                        // Weight Slider with display
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Weight:',
                                    style: TextStyle(fontSize: 16)),
                                Text(weight.toStringAsFixed(0),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Slider(
                              min: 5,
                              max: 500,
                              divisions: 495,
                              value: weight,
                              onChanged: (value) {
                                setState(() {
                                  weight = value;
                                });
                              },
                            ),
                          ],
                        ),

                        // RPE selector
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RPE (Rate of perceived exertion [0 easy, 5 difficult])',
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return GestureDetector(
                                  onTap: () => _setRPE(index),
                                  child: CircleAvatar(
                                    backgroundColor: rpe == index
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    child: Text('$index'),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Half: Next Suggested Workout
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.green.shade100,
              child: const Center(
                child: Column(
                  children: [
                    Text(
                      'Next Suggested Workout',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Based on Profile Goal and Previous Workout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
