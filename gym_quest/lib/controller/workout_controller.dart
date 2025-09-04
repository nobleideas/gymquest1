import 'package:gym_quest/model/workout.dart';

class WorkoutController {
  Future<String> loadWelcomeMessage() async {
    // This would normally call a model/service
    await Future.delayed(Duration(seconds: 1));
    return "Welcome to Gym Quest!";
  }

  Workout getCurrentWorkout() {
    // This would normally fetch from a model/service
    return Workout(id: "1", name: "Lat Pull Downs", imagePath: "assets/images/latpulldown.jpg",
    pop: "pull", mof: "machine", muscleGroup: MuscleGroup.back);
  }
}
