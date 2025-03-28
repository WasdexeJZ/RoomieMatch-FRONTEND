import 'package:flutter/material.dart';

import 'about_you_page.dart';

import '../../services/db_service.dart';

class BudgetPreferencePage extends StatefulWidget {
  @override
  State<BudgetPreferencePage> createState() => _BudgetPreferencePageState();
}

class _BudgetPreferencePageState extends State<BudgetPreferencePage> {
  double? _currentBudget; // Set to null initially to detect if user changes it

  void _validateAndNavigate() {
    if (_currentBudget == null) {
      _showErrorDialog('Please set your budget range.');
    } else {
      _updateStat("self", "registration", "8");

      _updateProfile("budget", (_currentBudget?.toInt() ?? 500).toString());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutYouPage()),
      );
    }
  }

  void _updateProfile(String field, String value) async {
    Map<String, String> response = await DBService.updateProfileField(field, value);

    _checkError(response);
  }

  void _updateStat(String userId, String key, String value) async {
    Map<String, String> response = await DBService.updateStat(userId, key, value);

    _checkError(response);
  }

  void _checkError(Map<String, String> response) {
    if (response["status"] == "ERROR") {
      _showErrorDialog(response["error"] ?? "An unknown error occurred.");
    } else if (response["status"] == "UNKNOWN") {
      _showErrorDialog("An unknown error occurred.");
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
