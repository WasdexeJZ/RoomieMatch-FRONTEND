import 'package:flutter/material.dart';

class SleepModePage extends StatefulWidget {
  const SleepModePage({super.key});

  @override
  _SleepModePageState createState() => _SleepModePageState();
}

class _SleepModePageState extends State<SleepModePage> {
  // State variables
  bool isSleepModeEnabled = false;
  TimeOfDay startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 0, minute: 0);
  List<bool> selectedDays = [false, false, false, false, false, false, false]; // S M T W T F S
  bool isSaved = false; // Track if the settings are saved

  // Function to pick time
  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? startTime : endTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF1C8585), // Clock circle and selected text color
              onPrimary: Colors.white, // Text color on primary color
              onSurface: Colors.black, // Default text color
            ),
            timePickerTheme: TimePickerThemeData(
              dialBackgroundColor: Colors.white, // Background color of the clock
              hourMinuteColor: const Color(0xFF1C8585), // Background color for hours and minutes
              hourMinuteTextColor: Colors.white, // Text color for hours and minutes
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Ensure white background
      appBar: AppBar(
        title: const Text('Sleep Mode'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // Navigate back to Notification Settings
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep Mode Toggle
            SwitchListTile(
              value: isSleepModeEnabled,
              onChanged: (value) {
                setState(() {
                  isSleepModeEnabled = value;
                  isSaved = false; // Mark as unsaved when settings change
                });
              },
              title: const Text(
                'Sleep mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                'Your notifications will be muted during the times you choose.',
                style: TextStyle(color: Colors.grey),
              ),
              activeColor: const Color(0xFF1C8585), // Thumb color
              activeTrackColor: const Color(0xFF1C8585).withOpacity(0.5), // Track color
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),

            // Start Time
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Start time'),
              trailing: TextButton(
                onPressed: () => _pickTime(context, true),
                child: Text(
                  startTime.format(context),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

            // End Time
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('End time'),
              trailing: TextButton(
                onPressed: () => _pickTime(context, false),
                child: Text(
                  endTime.format(context),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Choose Days
            const Text(
              'Choose days',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDays[index] = !selectedDays[index];
                      isSaved = false; // Mark as unsaved when settings change
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedDays[index]
                          ? const Color(0xFF1C8585)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                        style: TextStyle(
                          color: selectedDays[index] ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSaved = true; // Mark as saved when the button is pressed
                  });
                  // Add your logic to save settings here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isSaved ? Colors.grey[400] : const Color(0xFF1C8585), // Change color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  isSaved ? 'Saved' : 'Save',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
