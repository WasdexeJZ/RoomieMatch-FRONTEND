import 'package:flutter/material.dart';

import '../models/settings.dart';
import '../services/hive_service.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/main_init_service.dart';

import 'home.dart';
import 'register.dart';
import 'new_home.dart';

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
          MaterialPageRoute(builder: (context) => const NewHomePage()),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, //the column only take as much space as needed
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/RoomieMatch_logo.png',
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 30),

              // Username field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: const Offset(0, 5),
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

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                      offset: const Offset(0, 5),
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

              // Log In button
              ElevatedButton(
                onPressed: _logIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 27, 110, 96),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: const Text(
                  'Log In',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Register text link
              TextButton(
                onPressed: _goToRegisterPage,
                child: const Text('Don\'t have an account? Register here.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
