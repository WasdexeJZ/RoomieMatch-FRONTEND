import 'package:RoomieMatch/models/auth.dart';
import 'package:RoomieMatch/services/hive_service.dart';

class AuthBoxHelper {
  static void setIsAuthenticated(bool isAuthenticated) {
    Auth temp = HiveService.getAuth() ?? Auth();

    temp.isAuthenticated = isAuthenticated;

    HiveService.setAuth(temp);
  }




}
