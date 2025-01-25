import 'package:RoomieMatch/models/settings.dart';
import 'package:RoomieMatch/services/hive_service.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'swipe.dart';
import 'chat.dart';
import 'notifications.dart';
import 'faq.dart';
import 'notifications_settings.dart';
import 'login.dart';

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
            MaterialPageRoute(builder: (context) => SwipePage()),
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
            MaterialPageRoute(builder: (context) => NotificationsPage()),
          );
          break;
      }
    }
  }

  Widget _buildIcon(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.white : Colors.transparent,
      ),
      child: Center(
        child: ImageIcon(
          AssetImage(assetPath),
          size: 35,
          color: Colors.grey,
        ),
      ),
    );
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
                    onTap: () {},
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

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogInPage(),
                        ),
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
          color: const Color(0xFFC7FBD2), // Background color for the navigation bar
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
            elevation: 0, // Set to 0 to avoid default shadow
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
                icon: _buildIcon('assets/icons/notificationbutton.png', 2),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon('assets/icons/settingsbutton.png', 3),
                label: 'Settings',
              ),
            ],
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
