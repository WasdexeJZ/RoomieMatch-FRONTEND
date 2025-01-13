import 'package:flutter/material.dart';
import 'sleep_mode_page.dart'; // Import the Sleep Mode Page
import 'chat_page.dart';
import 'views/swipe.dart';
import 'settings_page.dart';
import '/notifications_page.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // State variables for toggle switches
  bool pauseAll = true;
  bool messages = true;
  bool matchRequests = true;

  int _selectedIndex = 3; // Default to Settings tab

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      // Navigate to different pages
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SwipePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
          break;
        case 2: // Navigate to Notifications Page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
          break;
      }
    }
  }


  Widget _buildIcon(String assetPath, bool isSelected) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.white : Colors.transparent,
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 30,
          height: 30,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Colors.white, // Match the app bar background to white
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black, // Ensure the back arrow is visible
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            const Text(
              'Push notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // Pause All Notifications
            SwitchListTile(
              value: pauseAll,
              onChanged: (value) {
                setState(() {
                  pauseAll = value;
                });
              },
              title: const Text('Pause all'),
              subtitle: const Text(
                'Temporarily pause notifications',
                style: TextStyle(color: Colors.grey),
              ),
              activeColor: const Color(0xFF1C8585), // Thumb color
              activeTrackColor: const Color(0xFF1C8585).withOpacity(0.5), // Track color
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            ),

            // Messages Notifications
            SwitchListTile(
              value: messages,
              onChanged: (value) {
                setState(() {
                  messages = value;
                });
              },
              title: const Text('Messages'),
              subtitle: const Text(
                'Enable or disable message notifications',
                style: TextStyle(color: Colors.grey),
              ),
              activeColor: const Color(0xFF1C8585), // Thumb color
              activeTrackColor: const Color(0xFF1C8585).withOpacity(0.5), // Track color
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            ),

            // New Match Requests Notifications
            SwitchListTile(
              value: matchRequests,
              onChanged: (value) {
                setState(() {
                  matchRequests = value;
                });
              },
              title: const Text('New match requests'),
              subtitle: const Text(
                'Enable or disable match request notifications',
                style: TextStyle(color: Colors.grey),
              ),
              activeColor: const Color(0xFF1C8585), // Thumb color
              activeTrackColor: const Color(0xFF1C8585).withOpacity(0.5), // Track color
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            ),

            // Sleep Mode
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: const Text('Sleep mode'),
              subtitle: const Text(
                'Automatically mute notifications at night or whenever you need to focus.',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                // Navigate to Sleep Mode settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SleepModePage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFC7FBD2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: const Color(0xFFC7FBD2),
            elevation: 0,
            selectedItemColor: Colors.grey,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: _buildIcon('assets/icons/homebutton.png', _selectedIndex == 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/icons/chatbutton.png', _selectedIndex == 1),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/icons/notificationbutton.png', _selectedIndex == 2),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/icons/settingsbutton.png', _selectedIndex == 3),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
