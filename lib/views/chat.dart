import 'package:flutter/material.dart';

import '../chat_detail_page.dart';
import 'swipe.dart';
import 'settings/settings.dart';
import 'home.dart';
import 'new_home.dart';
import 'notifications.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  int _selectedIndex = 1; // Default to "Chats" tab

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
            MaterialPageRoute(builder: (context) => NewHomePage()),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SwipePage()),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
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
        color: isSelected ? Colors.white : Colors.transparent, // White background for selected icon
      ),
      child: Center(
        child: ImageIcon(
          AssetImage(assetPath),
          size: 30, // Ensure all icons use the same size
          color: isSelected ? Colors.grey : Colors.grey, // Color stays grey
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Chats'),
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
      body: ListView(
        children: [
          // Chat with Emily
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: const AssetImage('assets/profile/1.jpg'), // Load from local file
            ),
            title: const Text('Emily'),
            subtitle: const Text('Nice to meet you too :)'),
            trailing: const Text('1:00 PM'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                    userName: 'Emily',
                    profileImageAsset: 'assets/profile/1.jpg', // Pass the correct local file path
                    messages: [
                      {'content': 'Hi Emily!', 'timestamp': '12:00 PM', 'isSender': true},
                      {'content': 'Nice to meet you too :)', 'timestamp': '1:00 PM', 'isSender': false},
                    ],
                  ),
                ),
              );
            },
          ),
          // Chat with Bruno
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: const AssetImage('assets/profile/2.jpg'), // Load from local file
            ),
            title: const Text('Bruno'),
            subtitle: const Text('Hello!'),
            trailing: const Text('12:00 AM'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(
                    userName: 'Bruno',
                    profileImageAsset: 'assets/profile/2.jpg', // Pass the correct local file path
                    messages: [
                      {'content': 'Hello Bruno!', 'timestamp': '11:30 PM', 'isSender': true},
                      {'content': 'Hey there!', 'timestamp': '12:00 AM', 'isSender': false},
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // BottomNavigationBar in build method
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
}
