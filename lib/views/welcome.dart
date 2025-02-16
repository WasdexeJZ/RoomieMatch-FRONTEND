import 'package:flutter/material.dart';

import '../services/hive_service.dart';

import 'swipe.dart';
import 'login.dart';

class WelcomePage extends StatefulWidget {
  final String title;

  const WelcomePage({super.key, required this.title});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    // Start a 1-second delay before navigating to the Login Page
    Future.delayed(const Duration(seconds: 1), () {
      if (HiveService.getAuth()?.isAuthenticated ?? false) {
        _goToSwipePage(context);
      } else {
        _goToLoginPage(context);
      }
    });
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  void _goToSwipePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SwipePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title text
            const Text(
              'Welcome to RoomieMatch!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            // Logo image
            Image.asset(
              'assets/RoomieMatch_logo.png', // Replace with your actual logo path
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            const Text(
              'A LOCATION BASED \n ROOMMATE MATCHING APP',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Show loading spinner while waiting for the delay
            const CircularProgressIndicator(), // This will show while waiting
          ],
        ),
      ),
    );
  }
}
