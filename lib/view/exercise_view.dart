import 'package:flutter/material.dart';
import 'package:gym_quest/services/api_service.dart';
import 'package:gym_quest/view/gym_summary_view.dart';
import '../controller/workout_controller.dart';
import '../model/exercise.dart';

class ExerciseView extends StatefulWidget {
  const ExerciseView({super.key});

  @override
  State<ExerciseView> createState() => _ExerciseViewState();
}

class _ExerciseViewState extends State<ExerciseView> {
  final WorkoutController workoutController = WorkoutController();
  late Exercise currentWorkout;

  int sets = 0;
  int reps = 0;
  double weight = 5;
  int rpe = 0;
  bool _submitWorkoutButtonClicked = false;
  bool _nextWorkoutButtonClicked = false;
  bool _previousWorkoutButtonClicked = true;

  @override
  void initState() {
    super.initState();
    currentWorkout = workoutController.getScannedWorkout();
    loadEquipment("abc123");
  }

  void loadEquipment(String qrCode) async {
  final data = await ApiService.getEquipmentByQR(qrCode);
  if (data != null) {
    print("Equipment: ${data["equipment"]["name"]}");
    print("Exercises:");
    for (var ex in data["exercises"]) {
      print("- ${ex["name"]} (${ex["primary_muscle"]})");
    }
  } else {
    print("Equipment not found");
  }
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

  void _onSecondaryButtonClick() {
    // Handle the second confirmation action here
    saveSession();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Exercise Logged!')));
  }

  void saveSession() async {
  final result = await ApiService.logSession(
    userId: 1,
    exerciseId: 2,
    weight: 45.0,
    reps: 12,
    notes: "RPE 8, seat 3",
  );
  print(result["message"]);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Exercise View'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GymSummaryView(
                    summary1Text:
                        "Chest: Bench Press (3x10)\nTriceps: Dips (3x12)\nCardio: 20 min treadmill",
                    summary2Text:
                        "Back: Lat Pull Downs (3x10)\nBiceps: Dumbbell Curls (3x12)\nCardio: 30 min sauna",
                    summary3Text:
                        "Legs: Leg Press (3x10)\nAbs: Leg Raises (3x12)\nCardio: 20 min Elliptical",
                  ),
                ),
              );
            },
            child: const Text('Gym Home View'),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 170, 125, 247),
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
                        Text(
                          'Last time you did this exercise',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 230,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(currentWorkout.imagePath),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentWorkout.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Sets: 3', style: const TextStyle(fontSize: 16)),
                        Text('Reps: 10', style: const TextStyle(fontSize: 16)),
                        Text(
                          'Weight: 170',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text('RPE: 3', style: const TextStyle(fontSize: 16)),
                        Text(
                          currentWorkout.pop,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          currentWorkout.muscleGroup.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
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
                        Text(
                          'Scanned Exercise',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Dynamic Image
                        Column(
                          children: [
                            SizedBox(
                              height: 124,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(currentWorkout.imagePath),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentWorkout.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Sets Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _changeSets(-1),
                            ),
                            Text(
                              'Sets: $sets',
                              style: const TextStyle(fontSize: 14),
                            ),
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
                            Text(
                              'Reps: $reps',
                              style: const TextStyle(fontSize: 14),
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Weight:',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  weight.toStringAsFixed(0),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
                            const SizedBox(height: 1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _submitWorkoutButtonClicked = true;
                                    });
                                  },
                                  child: Text('Submit Workout'),
                                ),
                                Visibility(
                                  visible: _submitWorkoutButtonClicked,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    onPressed: () {
                                      _onSecondaryButtonClick();
                                      Text(
                                        'Second button (verification) clicked!',
                                      );
                                      // Add any verification logic here
                                    },
                                    child: Text('Click to Confirm'),
                                  ),
                                ),
                              ],
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
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Next Suggested Exercise',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'Suggested exercise aligns with push or pull day based on your last exercise(s)\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _nextWorkoutButtonClicked = false;
                              _previousWorkoutButtonClicked = true;
                            });
                          },
                          child: Text('Previous Workout'),
                        ),
                        Column(
                          children: [
                            Visibility(
                              visible: _previousWorkoutButtonClicked,
                              child: Text(
                                'Chest Supported Row',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _previousWorkoutButtonClicked,
                              child: SizedBox(
                                height: 350,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    'assets/gifs/Chest-supported_row_GIF.gif',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Visibility(
                              visible: _nextWorkoutButtonClicked,
                              child: Text(
                                'Seated Cable Row',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _nextWorkoutButtonClicked,
                              child: SizedBox(
                                height: 350,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    'assets/gifs/seated-cable-row.gif',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image.asset(
                                'assets/images/compass.png',
                                height: 100,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _previousWorkoutButtonClicked = false;
                                  _nextWorkoutButtonClicked = true;
                                });
                              },
                              child: Text('Next Workout'),
                            ),
                          ],
                        ),
                      ],
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
