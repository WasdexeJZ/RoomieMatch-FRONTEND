import 'package:flutter/material.dart';
import 'info_page.dart';

class ChatDetailPage extends StatelessWidget {
  final String userId;
  final String userName; // Name of the person you are chatting with
  final String profileImageAsset; // Local asset image for the profile
  final List<Map<String, dynamic>> messages; // List of messages (content and sender info)

  const ChatDetailPage({
    super.key,
    required this.userId,
    required this.userName,
    required this.profileImageAsset, // Required local asset image
    required this.messages, // Messages specific to the user
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to the InfoPage when the profile picture is clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoPage(
                      name: userName,
                      age: '25', // Provide the age dynamically if available
                      imagePath: profileImageAsset,
                      distance: '5km', // Provide the distance dynamically if available
                      location: 'Sample Location',
                      about: 'Sample About Information',
                      preferences: ['Preference 1', 'Preference 2'],
                    ),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(profileImageAsset), // Use local asset image
              ),
            ),
            const SizedBox(width: 10),
            Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message['isSender']; // Check if the message is sent by the user

                return Column(
                  crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSender ? const Color(0xFFE3EFEF) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message['content'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: isSender ? const EdgeInsets.only(right: 8, bottom: 10) : const EdgeInsets.only(left: 8, bottom: 10),
                      child: Text(
                        message['timestamp'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          // Input field for new messages
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type something...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Correct placement for borderRadius
                        borderSide: BorderSide.none, // Correct placement for borderSide
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Image.asset(
                    'assets/icons/sendbutton.png', // Custom send icon
                    width: 32,
                    height: 32,
                  ),
                  onPressed: () {
                    // Handle sending message logic
                    print('Message sent!');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
