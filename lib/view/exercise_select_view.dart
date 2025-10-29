import 'package:flutter/material.dart';
import 'package:gym_quest/view/exercise_view.dart';

class ExerciseSelectView extends StatefulWidget {
  const ExerciseSelectView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExerciseSelectViewState createState() => _ExerciseSelectViewState();
}

class _ExerciseSelectViewState extends State<ExerciseSelectView> {
  String? selectedExercise;

  bool _submitSuggestionClicked = false;

  final List<String> exercises = [
    'Bicep Curl',
    'Shoulder Press',
    'Tricep Kickback',
    'Dumbbell Row',
    'Chest Press',
    'Chest Fly',
    'Lateral Raise',
    'Front Raise',
    'Hammer Curl',
    'Goblet Squat',
    'Deadlift',
    'Lunges',
    'Step Ups',
    'Shrugs',
    'Renegade Row',
    'Dumbbell Swing',
    'Single Arm Press',
    'Incline Chest Press',
    'Reverse Fly',
    'Concentration Curl',
  ];

  void _navigateToExerciseDetail(String exercise) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseView()));
  }

  void _onSecondaryButtonClick() {
    // Handle the second confirmation action here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Suggestion Sent!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Exercise Select View'),
        backgroundColor: const Color.fromARGB(255, 170, 125, 247),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Center Image
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'assets/images/dumbbell_rack.jpg', // placeholder
                        height: 250,
                      ),
                    ),
                    SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'assets/images/variable-machine.png', // placeholder
                        width: 250,
                      ),
                    ),
                    SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        'assets/images/calesthenics.jpg', // placeholder
                        width: 250,
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
              SizedBox(height: 32),

              // Dropdown Selector
              DropdownButtonFormField<String>(
                value: selectedExercise,
                hint: Text('Select an exercise'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                items: exercises
                    .map(
                      (exercise) => DropdownMenuItem(
                        value: exercise,
                        child: Text(exercise),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedExercise = value;
                    });
                    _navigateToExerciseDetail(value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Text Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Suggest a new exercise:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Elevated Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _submitSuggestionClicked = true;
                      });
                    },
                    child: Text('Submit Suggestion'),
                  ),
                  Visibility(
                    visible: _submitSuggestionClicked,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        _onSecondaryButtonClick();
                        Text('Second button (verification) clicked!');
                        // Add any verification logic here
                      },
                      child: Text('Click to Confirm'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
