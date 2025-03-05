import 'package:flutter/material.dart';

import 'chat.dart';
import 'swipe.dart';
import 'settings/settings.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatPage()),
      );
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SwipePage()),
      );
    }

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    }
  }

  Widget _buildIcon(String assetPath, int index) {
    bool isSelected = _selectedIndex == index;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.white : Colors.transparent, // White background for selected icon
      ),
      child: Center(
        child: ImageIcon(
          AssetImage(assetPath),
          size: 35,
          color: isSelected ? Colors.grey : Colors.grey, // Change color for selected/unselected
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Updated notifications data with local asset images
    final List<Map<String, dynamic>> notifications = [
      {
        'avatarPath': 'assets/profile/1.png', // Local asset image
        'title': 'Message',
        'description': 'You have a message from Emily!',
        'timestamp': '9:00 AM',
      },
      {
        'avatarPath': 'assets/profile/4.png', // Local asset image
        'title': 'Message',
        'description': 'You have a message from Zack!',
        'timestamp': '3:00 PM',
      },
      {
        'avatarPath': 'assets/profile/2.png', // Local asset image
        'title': 'Message',
        'description': 'You have a message from Bruno!',
        'timestamp': '5 Days Ago',
      },
      {
        'avatarPath': 'assets/profile/3.png', // Local asset image
        'title': 'Message',
        'description': 'You have a message from Jasnie!',
        'timestamp': '5 Days Ago',
      },
      {
        'avatarPath': 'assets/profile/6.png', // Local asset image
        'title': 'Message',
        'description': 'You have a message from Mimi!',
        'timestamp': '6 Days Ago',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final isAlternateRow = index % 2 == 0; // Alternate background color

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isAlternateRow ? const Color(0xFFE3EFEF) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(notification['avatarPath']), // Use AssetImage for local images
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        notification['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    Text(
                      notification['timestamp'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFC7FBD2), // Ensure green background
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
    );
  }
}
