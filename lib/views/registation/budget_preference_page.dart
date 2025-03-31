import 'package:flutter/material.dart';
import 'account_setup_page.dart';

class BudgetPreferencePage extends StatefulWidget {
  @override
  State<BudgetPreferencePage> createState() => _BudgetPreferencePageState();
}

class _BudgetPreferencePageState extends State<BudgetPreferencePage> {
  double _currentBudget = 500; // Default starting value

  void _validateAndNavigate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AccountSetupPage()),
    );
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
            Navigator.pop(context);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${_currentBudget.toInt()}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.teal,
                  ),
                ),
                Text(
                  "Min: \$100   Max: \$5000",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                showValueIndicator: ShowValueIndicator.always, // <- force tooltip
              ),
              child: Slider(
                value: _currentBudget,
                min: 100,
                max: 5000,
                label: "\$${_currentBudget.toInt()}",
                activeColor: Colors.teal,
                onChanged: (value) {
                  setState(() {
                    _currentBudget = (value / 100).round() * 100;
                  });
                },
              ),
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
