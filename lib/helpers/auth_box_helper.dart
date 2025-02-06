import '../models/auth.dart';
import '../services/hive_service.dart';

class AuthBoxHelper {
  static void setIsAuthenticated(bool isAuthenticated) {
    Auth temp = HiveService.getAuth() ?? Auth();

    temp.isAuthenticated = isAuthenticated;

    HiveService.setAuth(temp);
  }
}
