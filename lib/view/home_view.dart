import 'package:flutter/material.dart';
import 'package:gym_quest/view/exercise_select_view.dart';
import 'package:gym_quest/view/gym_summary_view.dart';
import 'package:gym_quest/view/login_view.dart';
import 'package:gym_quest/view/profile_view.dart';
import '../controller/home_controller.dart';
import 'exercise_view.dart';
import 'admin_view.dart';

class HomeView extends StatelessWidget {
    
  final HomeController controller = HomeController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),
      backgroundColor: const Color.fromARGB(255, 170, 125, 247),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: controller.loadWelcomeMessage(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Text(snapshot.data!);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const 
                  GymSummaryView(summary1Text: "Chest: Bench Press (3x10)\nTriceps: Dips (3x12)\nCardio: 20 min treadmill",
                  summary2Text: "Back: Lat Pull Downs (3x10)\nBiceps: Dumbbell Curls (3x12)\nCardio: 30 min sauna",
                  summary3Text: "Legs: Leg Press (3x10)\nAbs: Leg Raises (3x12)\nCardio: 20 min Elliptical",)),
                );
              },
              child: Text('Gym Home View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExerciseView()),
                );
              },
              child: Text('Exercise View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExerciseSelectView()),
                );
              },
              child: Text('Exercise Select View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              child: Text('Profile View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
              child: Text('Login View'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminView()),
                );
              },
              child: Text('Admin View'),
            ),
          ],
        ),
      ),
    );
  }
}



