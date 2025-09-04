enum MuscleGroup { chest, back, legs, arms, shoulders, core, fullBody }

class Workout {
  final String id;
  final String name;
  final String imagePath;
  final String pop;
  final String mof;
  final MuscleGroup muscleGroup;

  Workout({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.pop,
    required this.mof,
    required this.muscleGroup,
  });
}
