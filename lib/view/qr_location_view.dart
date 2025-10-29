import 'package:flutter/material.dart';

class QrLocationView extends StatefulWidget {
    @override
  State<QrLocationView> createState() => _QrLocationViewState();
}

class _QrLocationViewState extends State<QrLocationView> {
  bool _showSecondaryButton = false;
 
  void _onPrimaryButtonClick() {
    setState(() {
      _showSecondaryButton = true;
    });
  }

  void _onSecondaryButtonClick() {
    // Handle the second confirmation action here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location confirmed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Equipment Location'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image Placeholder
              Image.asset(
                'assets/images/bench-press.png', // Replace with your image path
                height: 400,
              ),
              SizedBox(height: 20),
              // Text Box
              Text("Flat Bench Press"),
              SizedBox(height: 20),
              // Primary Button
              ElevatedButton(
                onPressed: _onPrimaryButtonClick,
                child: Text('Click to Confirm Equipment Location'),
              ),
              SizedBox(height: 10),
              // Secondary Button (only appears after first click)
              if (_showSecondaryButton)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _onSecondaryButtonClick,
                  child: Text('Confirm Second Click'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
