import 'package:flutter/material.dart';
import 'username_password_page.dart';

class BudgetPreferencePage extends StatefulWidget {
  @override
  State<BudgetPreferencePage> createState() => _BudgetPreferencePageState();
}

class _BudgetPreferencePageState extends State<BudgetPreferencePage> {
  double? _currentBudget;  // Set to null initially to detect if user changes it

  void _validateAndNavigate() {
    if (_currentBudget == null) {
      _showErrorDialog('Please set your budget range.');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UsernamePasswordPage()),
      );
    }
  }

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
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Ensure it only goes back one step
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "What's your budget?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Drag the slider to set the budget range for your potential matches.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              "Budget range",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Slider(
              value: _currentBudget ?? 500,
              min: 100,
              max: 5000,
              divisions: 99, // Match distance preference page
              label: "\$${(_currentBudget ?? 500).toInt()}",
              activeColor: Colors.teal,
              onChanged: (value) {
                setState(() {
                  _currentBudget = value;
                });
              },
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _validateAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1C8585),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
