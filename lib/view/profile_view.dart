import 'package:flutter/material.dart';
import 'package:gym_quest/services/api_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});


  void showStats() async {
  final stats = await ApiService.getUserStats(1);
  for (var s in stats) {
    print("${s['primary_muscle']}: ${s['total_volume']} lbs total volume");
  }
}

  

  Widget _buildStat(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Overview'),
      ),
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Placeholder human figure box
                Container(
                  width: 120,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: const Center(
                    child: Text(
                      'Human\nFigure',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // Stats
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStat('Chest', 0),
                    _buildStat('Arms', 0),
                    _buildStat('Back', 0),
                    _buildStat('Legs', 0),
                    _buildStat('Shoulders', 0),
                    _buildStat('Abs', 0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
