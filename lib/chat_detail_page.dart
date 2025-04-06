import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'info_page.dart';
import './services/message_db_service.dart';
import './helpers/auth_box_helper.dart';

class ChatDetailPage extends StatefulWidget {
  final String userId;
  final String firstName; // Name of the person you are chatting with
  final String profileImageAsset; // Local asset image for the profile
  List<Map<String, dynamic>> messages = []; // List of messages (content and sender info)

  ChatDetailPage({super.key, required this.userId, required this.firstName, required this.profileImageAsset // Required local asset image
      // required this.messages, // Messages specific to the user
      });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();

    getMessages();
  }

  Future<void> getMessages() async {
    final List<Map<String, dynamic>> temp = await MessageDBService().getMessagesByUserId(AuthBoxHelper.getUserId(), widget.userId);

    DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:SS');

    for (int i = 0; i < temp.length; i++) {
      Map<String, dynamic> mes = {'content': "", "timestamp": "", "isSender": true};
      mes["content"] = temp[i]["plain_text"];

      DateTime dateTime = format.parse(temp[i]["timestamp"]);
      mes["timestamp"] = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

      if (temp[i]["sender_user_id"] == AuthBoxHelper.getUserId()) {
        mes["isSender"] = true;
      } else {
        mes["isSender"] = false;
      }

      widget.messages.add(mes);
    }

    setState(() => _isLoadingMessages = false);
  }

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
                      name: widget.firstName,
                      age: '25', // Provide the age dynamically if available
                      imagePath: widget.profileImageAsset,
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
                backgroundImage: AssetImage(widget.profileImageAsset), // Use local asset image
              ),
            ),
            const SizedBox(width: 10),
            Text(
              widget.firstName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingMessages
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.messages.length,
                    itemBuilder: (context, index) {
                      final message = widget.messages[index];
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
