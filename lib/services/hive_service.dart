import 'package:hive/hive.dart';

import '../models/auth.dart';
import '../models/user.dart';
import '../models/profile.dart';
import '../models/settings.dart';

class HiveService {
  static final authBox = Hive.box('authBox');
  static final appBox = Hive.box('appBox');

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

  static Profile? getProfile() {
    return appBox.get('profile');
  }

  static void setProfile(Profile profile) {
    appBox.put('profile', profile);
  }

  static Settings? getSettings() {
    return appBox.get('settings');
  }

  static void setSettings(Settings settings) {
    appBox.delete('settings');
    appBox.put('settings', settings);
  }
}
