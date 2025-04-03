import 'package:flutter/material.dart';

import '../../models/settings.dart';

import '../../services/db_service.dart';
import '../../services/hive_service.dart';
import '../../services/auth_service.dart';
import '../../services/main_init_service.dart';

import '../swipe.dart';
import '../chat.dart';
import 'faq.dart';
import 'notifications_settings.dart';
import '../login.dart';
import '../home.dart';
import '../notifications.dart';
import 'profile_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3; // Default to "Settings" tab
  bool isAccountPrivate = false; // State for Account Privacy toggle

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
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SwipePage()),
          );
          break;
      }
    }
  }

  Widget _buildIcon(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.white : Colors.transparent,
      ),
      child: Center(
        child: ImageIcon(
          AssetImage(assetPath),
          size: 30,
          color: Colors.grey,
        ),
      ),
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

  void _updateSettings(String field, String value) async {
    Map<String, String> response = await DBService.updateSettingsField(field, value);

    if (response["status"] == "ERROR") {
      _showErrorDialog(response["error"] ?? "An unknown error occurred.");
    } else if (response["status"] == "UNKNOWN") {
      _showErrorDialog("An unknown error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = HiveService.getSettings() ?? Settings();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFE3EFEF),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF1C8585)), // Match homepage icon color
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFE3EFEF),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: const AssetImage(
                    'assets/profile/11.jpeg',
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Erika',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Kuala Lumpur, Malaysia',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                children: [
                  ListTile(
                    leading: _buildCustomIcon(
                      'assets/icons/profile.png',
                      const Color(0xFF1C8585),
                    ),
                    title: const Text('Profile'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileSettingsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: _buildCustomIcon(
                      'assets/icons/notifications.png',
                      const Color(0xFF1C8585),
                    ),
                    title: const Text('Notifications'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationSettingsPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: _buildCustomIcon(
                      'assets/icons/privacy.png',
                      const Color(0xFF1C8585),
                    ),
                    title: const Text('Account Privacy'),
                    trailing: Switch(
                      value: settings.accountPrivacy,
                      onChanged: (value) {
                        setState(() {
                          settings.accountPrivacy = value;
                        });

                        HiveService.setSettings(settings);

                        if (value) {
                          _updateSettings('accountPrivacy', 'T');
                        } else {
                          _updateSettings('accountPrivacy', 'F');
                        }
                      },
                      activeColor: const Color(0xFF1C8585),
                      activeTrackColor: const Color(0xFF1C8585).withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: _buildCustomIcon(
                      'assets/icons/faq.png',
                      const Color(0xFF1C8585),
                    ),
                    title: const Text('FAQs'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FAQPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: _buildCustomIcon(
                      'assets/icons/logout.png',
                      Colors.grey,
                    ),
                    title: const Text('Logout'),
                    onTap: () async {
                      await AuthService.signOut();
                      await MainInitService.stopService();
                      HiveService.deleteUser();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LogInPage()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: SizedBox(
          height: 80, // Change this value to make it thinner or thicker
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
                  icon: _buildIcon('assets/icons/homebutton.png', 0),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon('assets/icons/chatbutton.png', 1),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon('assets/icons/swipepage.png', 2),
                  label: 'Swipe',
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon('assets/icons/settingsbutton.png', 3),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomIcon(String assetPath, Color backgroundColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          assetPath,
          width: 30,
          height: 30,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
