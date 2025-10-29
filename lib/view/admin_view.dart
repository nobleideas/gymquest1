import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gym_quest/view/qr_location_view.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  String? _statusMessage;

  Future<void> _pickAndSaveCsv() async {
    // Pick the CSV file
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    centerTitle: true,
    title: const Text('QR Code Generator'),
    backgroundColor: const Color.fromARGB(255, 170, 125, 247),
  ),
  body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- Existing buttons ---
        ElevatedButton(
          onPressed: _pickAndSaveCsv,
          child: const Text(
            'Select CSV File to onBoard Machines, and Variable Equipment / Areas',
          ),
        ),
        if (_statusMessage != null) ...[
          const SizedBox(height: 20),
          Text(_statusMessage!),
        ],
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QrLocationView()),
            );
          },
          child: const Text('Go to QR Code Location View'),
        ),

        const SizedBox(height: 40),

        // --- Inbox Section ---
        const Text(
          "Inbox",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true, // allows ListView inside Column
          physics: const NeverScrollableScrollPhysics(), // disable inner scroll
          itemCount: 3, // demo messages
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final messages = [
              {
                "sender": "Coach John",
                "message": "Dumbbell Rack - Flying Dutchmans",
                "time": "10:15 AM"
              },
              {
                "sender": "Workout Buddy",
                "message": "Ab Lounge - Core Crushers",
                "time": "9:02 AM"
              },
              {
                "sender": "Taylor Swift",
                "message": "Bowflex - Long Bar T Pulls",
                "time": "Yesterday"
              },
            ];
            final msg = messages[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple[200],
                  child: Text(
                    msg["sender"]![0], // first letter
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  msg["sender"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  msg["message"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  msg["time"]!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Open message from ${msg["sender"]}")),
                  );
                },
              ),
            );
          },
        ),
      ],
    ),
  ),
);

  }
}
