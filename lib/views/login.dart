import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../services/hive_service.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/main_init_service.dart';

import 'home.dart';
import 'register.dart'; // Import the RegisterPage (if you have one)

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Simple login logic
  void _logIn() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in both fields.');
    } else {
      // Map<String, String> response = await AuthService.login(username, password);

      // if (response["status"] == "OK") {
      //   await MainInitService.requestPermissions();
      //   MainInitService.initService();
      //   await MainInitService.startService();

      //   _getAllSettings();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      // } else if (response["status"] == "ERROR") {
      //   _showErrorDialog(response["error"] ?? "An unknown error occurred.");
      // } else if (response["status"] == "UNKNOWN") {
      //   _showErrorDialog("An unknown error occurred.");
      // }
    }
  }

  void _getAllSettings() async {
    Map<String, dynamic> response = await DBService.getAllSettings();

    if (response["status"] == "ERROR") {
      _showErrorDialog(response["error"] ?? "An unknown error occurred.");
    } else if (response["status"] == "UNKNOWN") {
      _showErrorDialog("An unknown error occurred.");
    } else if (response["status"] == "OK") {
      HiveService.deleteSettings();

      Settings settings = Settings();
      settings.notifPauseAll = response["notifPauseAll"] == "T" ? true : false;
      settings.notifMessages = response["notifMessages"] == "T" ? true : false;
      settings.notifNewMatch = response["notifNewMatch"] == "T" ? true : false;
      settings.sleepMode = response["sleepMode"] == "T" ? true : false;
      settings.sleepStartTime = response["sleepStartTime"];
      settings.sleepEndTime = response["sleepEndTime"];
      for (int i = 0; i < 7; i++) {
        settings.sleepChooseDays[i] = response["sleepChooseDays"][i] == "T" ? true : false;
      }
      settings.accountPrivacy = response["accountPrivacy"] == "T" ? true : false;

      HiveService.setSettings(settings);
    }
  }

  // Navigate to the Register Page
  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()), // Update with your actual RegisterPage
    );
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Login via social media with SnackBar message
  void _logInWithSocialMedia(String platform) {
    // Clear any existing SnackBars before showing the new one
    ScaffoldMessenger.of(context).clearSnackBars();

    // Display a new SnackBar with the platform name and set a custom duration
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logging in via $platform'),
        duration: const Duration(seconds: 1), // Set the duration to 2 seconds
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Spacer to push the logo higher
            const Spacer(flex: 2),

            // Add the RoomieMatch logo
            Image.asset(
              'assets/RoomieMatch_logo.png',
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 30),

            // Username field with shadow only at the bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5), // Shadow only at the bottom
                  ),
                ],
              ),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password field with shadow only at the bottom
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5), // Shadow only at the bottom
                  ),
                ],
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Green Log In button with white bold text
            ElevatedButton(
              onPressed: _logIn,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 27, 110, 96), // Green background
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                'Log In',
                style: TextStyle(
                  color: Colors.white, // White text
                  fontWeight: FontWeight.bold, // Bold font
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Separator text
            const Text(
              '─────────  or log in with  ─────────',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

            // Social media login buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google button
                GestureDetector(
                  onTap: () => _logInWithSocialMedia('Google'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Light gray border
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/google_logo.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Facebook button
                GestureDetector(
                  onTap: () => _logInWithSocialMedia('Facebook'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Light gray border
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/facebook_logo.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Apple button
                GestureDetector(
                  onTap: () => _logInWithSocialMedia('Apple'),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey, // Light gray border
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/apple_logo.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Spacer for layout balance
            const Spacer(),

            // TextButton to navigate to the Register Page
            TextButton(
              onPressed: _goToRegisterPage,
              child: const Text('Don\'t have an account? Register here.'),
            ),
          ],
        ),
      ),
    );
  }
}
