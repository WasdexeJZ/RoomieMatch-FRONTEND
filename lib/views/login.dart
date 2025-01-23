import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../style.dart'; // Import the styles file

import 'swipe.dart';
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
      Map<String, String> response = await AuthService.login(username, password);

      if (response["status"] == "OK") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SwipePage()),
        );
      } else if (response["status"] == "ERROR") {
        _showErrorDialog(response["error"] ?? "An unknown error occurred.");
      } else if (response["status"] == "UNKNOWN") {
        _showErrorDialog("An unknown error occurred.");
      }
    }
  }

  // Navigate to the Register Page
  void _goToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()), // Update with your actual RegisterPage
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

    // Display a new SnackBar with the platform name
    final snackBar = SnackBar(content: Text('Logging in via $platform'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar); // Show SnackBar
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the RoomieMatch logo at the top
            Image.asset(
              'assets/RoomieMatch_logo.png', // Ensure the image is in the 'assets' folder
              height: 100, // Set the height of the image
              width: 100, // Set the width of the image
            ),
            const SizedBox(height: 40), // Add some space below the image

            // Username field with shadow and white background
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _usernameController,
                decoration: AppTextStyles.textFieldDecoration.copyWith(
                  labelText: 'Username', // Customize label if needed
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password field with shadow and white background
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: AppTextStyles.passwordFieldDecoration.copyWith(
                  labelText: 'Password', // Customize label if needed
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logIn,
              child: const Text('Log In'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google login button with square border
                GestureDetector(
                  onTap: () => _logInWithSocialMedia('Google'),
                  child: Container(
                    width: 40, // Set the width of the container
                    height: 40, // Set the height of the container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2), // Add border
                      borderRadius: BorderRadius.circular(10), // Make the border square with rounded corners
                    ),
                    child: Image.asset(
                      'assets/google_logo.png',
                      width: 30, // Adjust the size of the image
                      height: 30, // Adjust the size of the image
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Add spacing between buttons

                // Facebook login button with smaller size and square border
                GestureDetector(
                  onTap: () => _logInWithSocialMedia('Facebook'),
                  child: Container(
                    width: 40, // Set the width of the container
                    height: 40, // Set the height of the container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2), // Add border
                      borderRadius: BorderRadius.circular(10), // Square with rounded corners
                    ),
                    child: Image.asset(
                      'assets/facebook_logo.png',
                      width: 30, // Adjust the size of the image
                      height: 30, // Adjust the size of the image
                    ),
                  ),
                ),
                const SizedBox(width: 20), // Add spacing between buttons

                // Apple login button with smaller size and square border
                GestureDetector(
                  onTap: () => _logInWithSocialMedia('Apple'),
                  child: Container(
                    width: 40, // Set the width of the container
                    height: 40, // Set the height of the container
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2), // Add border
                      borderRadius: BorderRadius.circular(10), // Square with rounded corners
                    ),
                    child: Image.asset(
                      'assets/apple_logo.png',
                      width: 30, // Adjust the size of the image
                      height: 30, // Adjust the size of the image
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
