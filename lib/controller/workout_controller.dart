import 'package:gym_quest/model/exercise.dart';

class WorkoutController {
  Future<String> loadWelcomeMessage() async {
    // This would normally call a model/service
    await Future.delayed(Duration(seconds: 1));
    return "Welcome to Gym Quest!";
  }

  Exercise getScannedWorkout() {
    // This would normally fetch from a model/service
    return Exercise(id: 1, name: "Lat Pull Down", imagePath: "assets/images/latpulldown.jpg",
    pop: "pull", muscleGroup: 'back');
  }
}
