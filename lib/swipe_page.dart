import 'package:flutter/material.dart';
import 'package:test/chat_page.dart';
import 'package:test/notifications_page.dart';
import 'package:test/filter_page.dart';
import 'package:test/info_page.dart';
import 'package:test/settings_page.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Map<String, String>> _photoData = [
    {'image': 'assets/profile/8.png', 'name': 'Ahmad', 'age': '24', 'distance': '1km'},
    {'image': 'assets/profile/9.png', 'name': 'Alex', 'age': '22', 'distance': '5km'},
    {'image': 'assets/profile/10.png', 'name': 'John', 'age': '27', 'distance': '8km'},
  ];
  int _currentPhotoIndex = 0;

  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;

  @override
  void initState() {
    super.initState();

    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeInOut,
    ));

    _swipeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentPhotoIndex = (_currentPhotoIndex + 1) % _photoData.length;
        });

        _swipeController.reset();
      }
    });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
        break;
      case 2:
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

  void _openFilterOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 8,
              color: Colors.white,
              child: FilterWidget(
                initialDistance: "0 km-10 km",
                initialGenderIndex: 0,
                initialMinAge: 22,
                initialMaxAge: 34,
                initialMinBudget: 550,
                initialMaxBudget: 1200,
                onApply: (distance, genderIndex, minAge, maxAge, minBudget, maxBudget) {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _swipePhoto(bool toRight) {
    setState(() {
      _swipeAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: toRight ? const Offset(1.5, 0.0) : const Offset(-1.5, 0.0),
      ).animate(CurvedAnimation(
        parent: _swipeController,
        curve: Curves.easeInOut,
      ));
    });

    _swipeController.forward();
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/filter.png',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              _openFilterOverlay(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: SlideTransition(
              position: _swipeAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        _photoData[_currentPhotoIndex]['image']!,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 70,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_photoData[_currentPhotoIndex]['name']}, ${_photoData[_currentPhotoIndex]['age']}',
                            style: const TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${_photoData[_currentPhotoIndex]['distance']}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 5,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.08,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 40),
                    onPressed: () {
                      _swipePhoto(false); // Swipe left
                    },
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1C8585),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.info, color: Colors.white, size: 27),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoPage(
                            name: _photoData[_currentPhotoIndex]['name']!,
                            age: _photoData[_currentPhotoIndex]['age']!,
                            imagePath: _photoData[_currentPhotoIndex]['image']!,
                            distance: _photoData[_currentPhotoIndex]['distance']!,
                            location: 'Sample Location',
                            about: 'Sample About Information',
                            preferences: ['Preference 1', 'Preference 2'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.check, color: Colors.green, size: 40),
                    onPressed: () {
                      _swipePhoto(true); // Swipe right
                    },
                  ),
                ),
              ],
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
}
