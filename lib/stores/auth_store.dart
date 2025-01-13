import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthStore with ChangeNotifier {
  User? _user;
  bool isAuthenticated = false;

  String? get getUserName => _user?.getName;
  String? get getUserEmail => _user?.getEmail;
  bool get getIsAuthenticated => isAuthenticated;

  set setIsAuthenticated(bool isAuthenticated) {
    this.isAuthenticated = isAuthenticated;
    notifyListeners();
  }

  set setUser(User user) {
    _user = user;
  }

  AuthStore() {}
}
