
class Exercise {
  final int? id;
  final String name;
  final String imagePath;
  final String pop;
  final String muscleGroup;
  final List<String>? variations;

  Exercise({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.pop,
    required this.muscleGroup,
    this.variations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pop': pop,
      'muscle_group': muscleGroup,
      'variations': variations,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      pop: map['pop'],
      muscleGroup: map['muscle_group'], 
      imagePath: 'imagePath', // Placeholder, adjust as needed
    );
  }
}

class ExerciseRepository {
  static final ExerciseRepository _instance = ExerciseRepository._internal();
  final List<Exercise> _workouts = [];

  factory ExerciseRepository() {
    return _instance;
  }

  ExerciseRepository._internal();

  List<Exercise> getAllWorkouts() => List.unmodifiable(_workouts);

  // Create a sublist of objects where the 'value' property is 10
  List<Exercise> get pullExercises => _workouts.where((obj) => obj.pop == 'pull').toList();
  List<Exercise> get pushExercises => _workouts.where((obj) => obj.pop == 'push').toList();
  List<Exercise> get legExercises => _workouts.where((obj) => obj.pop == 'legs').toList();
  List<Exercise> get coreExercises => _workouts.where((obj) => obj.pop == 'core').toList();

  void addWorkout(Exercise workout) {
    _workouts.add(workout);
  }

  void removeWorkout(Exercise workout) {
    _workouts.remove(workout);
  }

  void clear() {
    _workouts.clear();
  }
}
