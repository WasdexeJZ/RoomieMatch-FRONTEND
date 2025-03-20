import 'package:flutter/material.dart';
import 'all_setup_page.dart';

class YourInterestPage extends StatefulWidget {
  @override
  _YourInterestPageState createState() => _YourInterestPageState();
}

class _YourInterestPageState extends State<YourInterestPage> {
  String? selectedGuests;
  String? selectedSocial;
  String? selectedNoise;
  String? selectedCleaning;
  String? selectedSmoking;

  void _validateAndNavigate() {
    if (selectedGuests == null ||
        selectedSocial == null ||
        selectedNoise == null ||
        selectedCleaning == null ||
        selectedSmoking == null) {
      _showErrorDialog('Please answer all questions before proceeding.');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllSetUpPage()),
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

  /// **Reusable Option Button (Matching About You Page)**
  Widget _optionButton(String label, String? groupValue, Function(String) onSelect) {
    bool isSelected = groupValue == label;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => onSelect(label)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12), // Thinner box height
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF1C8585).withOpacity(0.15) : Colors.grey[200], // Light green highlight when selected
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black), // Normal black text
            ),
          ),
        ),
      ),
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What are you into?",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Novelty is such a drag, get straight with us NOW!",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 16),

                  // Guests Question
                  Text('How do you feel about your roommate hosting guests?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(children: [
                    _optionButton('Often', selectedGuests, (value) => selectedGuests = value),
                    SizedBox(width: 8),
                    _optionButton('Occasionally', selectedGuests, (value) => selectedGuests = value),
                    SizedBox(width: 8),
                    _optionButton('Never', selectedGuests, (value) => selectedGuests = value),
                  ]),

                  SizedBox(height: 16),

                  // Social Preference
                  Text('Do you prefer a roommate who’s social or more private?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(children: [
                    _optionButton('Social', selectedSocial, (value) => selectedSocial = value),
                    SizedBox(width: 8),
                    _optionButton('Private', selectedSocial, (value) => selectedSocial = value),
                    SizedBox(width: 8),
                    _optionButton('Balanced', selectedSocial, (value) => selectedSocial = value),
                  ]),

                  SizedBox(height: 16),

                  // Noise Preference
                  Text('Are you okay with a roommate who enjoys playing music or watching loud TV?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(children: [
                    _optionButton('Yes', selectedNoise, (value) => selectedNoise = value),
                    SizedBox(width: 8),
                    _optionButton('No', selectedNoise, (value) => selectedNoise = value),
                  ]),

                  SizedBox(height: 16),

                  // Cleaning Preference
                  Text('How important is it for your roommate to contribute to cleaning and chores?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(children: [
                    _optionButton('Very important', selectedCleaning, (value) => selectedCleaning = value),
                    SizedBox(width: 8),
                    _optionButton('Somewhat', selectedCleaning, (value) => selectedCleaning = value),
                    SizedBox(width: 8),
                    _optionButton('Not important', selectedCleaning, (value) => selectedCleaning = value),
                  ]),

                  SizedBox(height: 16),

                  // Smoking Preference
                  Text('Are you okay with a roommate who smokes?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(children: [
                    _optionButton('Yes', selectedSmoking, (value) => selectedSmoking = value),
                    SizedBox(width: 8),
                    _optionButton('No', selectedSmoking, (value) => selectedSmoking = value),
                    SizedBox(width: 8),
                    _optionButton('Only outside', selectedSmoking, (value) => selectedSmoking = value),
                  ]),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // "Next" button fixed at bottom
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Ensures spacing
            child: SizedBox(
              height: 50, // Ensures consistent height across pages
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

