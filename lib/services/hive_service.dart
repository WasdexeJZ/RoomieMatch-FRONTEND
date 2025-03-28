import 'package:hive/hive.dart';

import '../models/auth.dart';
import '../models/user.dart';
import '../models/profile.dart';
import '../models/settings.dart';
import '../models/preference.dart';

class HiveService {
  static final authBox = Hive.box('authBox');
  static final appBox = Hive.box('appBox');

  static Auth? getAuth() {
    return authBox.get('auth');
  }

  static void setAuth(Auth auth) {
    authBox.put('auth', auth);
  }

  static User getUser() {
    return authBox.get('user') ?? User();
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

  static Profile getProfile() {
    return appBox.get('profile') ?? Profile();
  }

  static void setProfile(Profile profile) {
    appBox.put('profile', profile);
  }

  static void deleteProfile() {
    appBox.delete('profile');
  }

  static Settings getSettings() {
    return appBox.get('settings') ?? Settings();
  }

  static void setSettings(Settings settings) {
    appBox.put('settings', settings);
  }

  static void deleteSettings() {
    appBox.delete('settings');
  }

  static Preference getPreference() {
    return appBox.get('preference') ?? Preference();
  }

  static void setPreference(Preference preference) {
    appBox.put('preference', preference);
  }

  static void deletePreference() {
    appBox.delete('preference');
  }
}
