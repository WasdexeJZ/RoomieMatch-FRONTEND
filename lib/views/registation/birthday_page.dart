import 'package:flutter/material.dart';

import 'gender_selection_page.dart'; // Next page after this

import '../../services/db_service.dart';

class BirthdayPage extends StatefulWidget {
  @override
  State<BirthdayPage> createState() => _BirthdayPageState();
}

class _BirthdayPageState extends State<BirthdayPage> {
  final TextEditingController birthdateController = TextEditingController();

  void _validateAndNavigate() {
    if (birthdateController.text.trim().isEmpty) {
      _showErrorDialog('Please enter your birth date.');
    } else {
      _updateStat("self", "registration", "4");

      _updateProfile("birthday", birthdateController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GenderSelectionPage()),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "What's your B-Day?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: birthdateController,
              decoration: InputDecoration(
                hintText: 'MM / DD / YYYY',
                border: UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 8),
            Text(
              "Your profile shows your age, not your birth date.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
