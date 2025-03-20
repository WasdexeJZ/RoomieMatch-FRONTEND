import 'package:flutter/material.dart';

import '../services/hive_service.dart';
import '../services/api_service.dart';
import '../services/main_init_service.dart';

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
    Future.delayed(const Duration(seconds: 1), () async {
      //await initBackendConnection();

      if (HiveService.getAuth()?.isAuthenticated ?? false) {
        _goToSwipePage(context);
      } else {
        _goToLoginPage(context);
      }
    });
  }

  /*Future<void> initBackendConnection() async {
    String apiResponseStatus;
    bool isIteration = false;
    List<bool> hasErrorDialog = [false];

    do {
      ApiService apiService = ApiService();

      Map<String, dynamic> apiResponse = await apiService.get('utils/frontend-connection-check/');
      apiResponseStatus = apiResponse['status'];

      if (isIteration) {
        if (!hasErrorDialog[0]) {
          _showErrorDialog("Connection to Backend Failed. Please ensure you have Internet Connection.", hasErrorDialog);
          hasErrorDialog[0] = true;
        }
        await Future.delayed(Duration(seconds: 30));
      }

      isIteration = true;
    } while (apiResponseStatus != "OK");

    if (hasErrorDialog[0]) {
      Navigator.of(context).pop();
    }

    await MainInitService.initAuth();
  }*/

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

  // Show error dialog
  void _showErrorDialog(String message, List<bool> hasErrorDialog) {
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
                hasErrorDialog[0] = false;
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
              'assets/RoomieMatch_logo.png',
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
