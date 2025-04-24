import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../services/db_service.dart';

import '../filter_page.dart';
import '../info_page.dart';
import 'home.dart';
import 'chat.dart';
import 'settings/settings.dart';
import 'notifications.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> _photoData = [];
  List<Map<String, dynamic>> _displayData = [];

  int _selectedDistance = 99;
  int _selectedGenderIndex = 2;
  int _minAge = 18;
  int _maxAge = 60;
  int _minBudget = 250;
  int _maxBudget = 3000;

  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;

  int _currentPhotoIndex = 0;

  int _selectedIndex = 2; // Default to "Swipe" tab
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    getMatches();

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
          // _currentPhotoIndex = (_currentPhotoIndex + 1) % _photoData.length;
          _currentPhotoIndex = _currentPhotoIndex + 1;
        });
        _swipeController.reset();
      }
    });
  }

  void filterMatches(int distance, int genderIndex, double minAge, double maxAge, double minBudget, double maxBudget) {
    _currentPhotoIndex = 0;
    _displayData.clear();

    for (int i = 0; i < _photoData.length; i++) {
      _displayData.add(_photoData[i]);
    }

    print(_displayData.length);

    _selectedDistance = distance;
    _selectedGenderIndex = genderIndex;
    _minAge = minAge.round();
    _maxAge = maxAge.round();
    _minBudget = minBudget.round();
    _maxBudget = maxBudget.round();

    for (int i = _displayData.length - 1; i >= 0; i--) {
      print(i);
      if (_selectedDistance != 99) {
        if (_selectedDistance < int.parse(_displayData[i]["distance"])) {
          _displayData.removeAt(i);

          continue;
        }
      }

      if (_selectedGenderIndex != 2) {
        if (_selectedGenderIndex == 0 && _displayData[i]["gender"] == "F") {
          _displayData.removeAt(i);

          continue;
        } else if (_selectedGenderIndex == 1 && _displayData[i]["gender"] == "M") {
          _displayData.removeAt(i);

          continue;
        }
      }

      if (int.parse(_displayData[i]["age"]) < _minAge || _maxAge < int.parse(_displayData[i]["age"])) {
        _displayData.removeAt(i);

        continue;
      }

      if (int.parse(_displayData[i]["budget"]) < _minBudget || _maxBudget < int.parse(_displayData[i]["budget"])) {
        _displayData.removeAt(i);

        continue;
      }

   }

   setState(() {
        _displayData.add({});
        _displayData.removeAt(_displayData.length - 1);
      });
    
      print(_displayData);
      print(_displayData.length);

    Navigator.pop(context);
  }

  Future<void> getMatches() async {
    Map<String, dynamic> response = await DBService.getAllMatches();

    if (response["status"] == "ERROR" && response["error"] == "No record found!") {
    } else if (response["status"] == "UNKNOWN") {
      _showErrorDialog("An unknown error occurred.");
    } else if (response["status"] == "OK") {
      // Get all matches
      for (int i = 0; i < response['matches'].length; i++) {
        Map<String, dynamic> match = response['matches'][i];
        _photoData.add(
            {'user_id': match['user_id'], 'image': 'assets/profile/9.png', 'name': match['first_name'] ?? "", 'age': match['age'].toString(), "gender": match['gender'] ?? "", "distance": match['distance'].toString(), "budget": match['budget'].toString(), "match_score": match['match_score'] ?? ""});
        _displayData.add(
            {'user_id': match['user_id'], 'image': 'assets/profile/9.png', 'name': match['first_name'] ?? "", 'age': match['age'].toString(), "gender": match['gender'] ?? "", "distance": match['distance'].toString(), "budget": match['budget'].toString(), "match_score": match['match_score'] ?? ""});
      }

      // Sort matches by match_score, higher first, descending order
      _photoData.sort((a, b) => b['match_score'].compareTo(a['match_score']));
      _displayData.sort((a, b) => b['match_score'].compareTo(a['match_score']));

      for (int i = _displayData.length - 1; i >= 0; i--) {
        if (_selectedDistance != 99) {
          if (_selectedDistance < int.parse(_displayData[i]["distance"])) {
            _displayData.removeAt(i);

            continue;
          }
        }

        if (_selectedGenderIndex != 2) {
          if (_selectedGenderIndex == 0 && _displayData[i]["gender"] == "F") {
            _displayData.removeAt(i);

            continue;
          }

          if (_selectedGenderIndex == 1 && _displayData[i]["gender"] == "M") {
            _displayData.removeAt(i);

            continue;
          }
        }

        if (int.parse(_displayData[i]["age"]) < _minAge || _maxAge < int.parse(_displayData[i]["age"])) {
          _displayData.removeAt(i);

          continue;
        }

        if (int.parse(_displayData[i]["budget"]) < _minBudget || _maxBudget < int.parse(_displayData[i]["budget"])) {
          _displayData.removeAt(i);

          continue;
        }

        setState(() {
          _displayData.add({});
          _displayData.removeAt(_displayData.length - 1);
        });
      }

      print("init");
      print(_displayData.length);
    }

    setState(() => _isLoading = false);
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

  void _updateMatch(String compare_user_id, int curr_match_type) async {
    Map<String, String> response = await DBService.updateMatch(compare_user_id, curr_match_type);

    if (response["status"] == "ERROR") {
      _showErrorDialog(response["error"] ?? "An unknown error occurred.");
    } else if (response["status"] == "UNKNOWN") {
      _showErrorDialog("An unknown error occurred.");
    }
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
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
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
                initialDistance: _selectedDistance,
                initialGenderIndex: _selectedGenderIndex,
                initialMinAge: _minAge,
                initialMaxAge: _maxAge,
                initialMinBudget: _minBudget,
                initialMaxBudget: _maxBudget,
                onApply: filterMatches,
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

    // Update database
    if (toRight) {
      _updateMatch(_photoData[_currentPhotoIndex]['user_id'], 1);
    } else {
      _updateMatch(_photoData[_currentPhotoIndex]['user_id'], 0);
    }

    _swipeController.forward();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Welcome User!'),
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
          // Filter Icon
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: _currentPhotoIndex >= _displayData.length
                  ? [Center(child: CircularProgressIndicator())]
                  : [
                      Center(
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            if (details.delta.dx > 10) {
                              _swipePhoto(true);
                            } else if (details.delta.dx < -10) {
                              _swipePhoto(false);
                            }
                          },
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
                                      _displayData[_currentPhotoIndex]['image']!,
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
                                          '${_displayData[_currentPhotoIndex]['name']}, ${_displayData[_currentPhotoIndex]['age']}',
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
                                          '${_displayData[_currentPhotoIndex]['distance']} km',
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
                                        name: _displayData[_currentPhotoIndex]['name']!,
                                        age: _displayData[_currentPhotoIndex]['age']!,
                                        imagePath: _displayData[_currentPhotoIndex]['image']!,
                                        distance: _displayData[_currentPhotoIndex]['distance']!,
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
