import 'package:RoomieMatch/models/auth.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';

class HiveService {
  static final authBox = Hive.box('authBox');
  // static final appBox = Hive.box('appBox');

  static Auth? getAuth() {
    return authBox.get('auth');
  }

  static void setAuth(Auth auth) {
    authBox.put('auth', auth);
  }

  static User? getUser() {
    return authBox.get('user');
  }

  static void setUser(User user) {
    authBox.put('user', user);
  }

  static void deleteUser() {
    authBox.delete('user');
  }

  static void clearAuthBox() {
    authBox.clear();
  }
}
