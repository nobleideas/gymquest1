import 'package:flutter/material.dart';
import 'package:gym_quest/view/profile_view.dart';
import '../controller/home_controller.dart';
import 'workout_view.dart';
import 'admin_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = HomeController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
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
                  MaterialPageRoute(builder: (context) => const WorkoutView()),
                );
              },
              child: Text('Go to Workout View /// After QR Scan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminView()),
                );
              },
              child: Text('Go to Admin View /// Gym onBoarding'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileView()),
                );
              },
              child: Text('Go to Profile View'),
            ),
          ],
        ),
      ),
    );
  }
}
