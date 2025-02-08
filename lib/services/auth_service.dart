import 'package:supertokens_flutter/supertokens.dart';

import '../helpers/auth_box_helper.dart';
import '../models/user.dart';
import './hive_service.dart';
import './api_service.dart';

class AuthService {
  static final ApiService apiService = ApiService();

  AuthService();

  // Login Function
  //
  static Future<Map<String, String>> login(String email, String password) async {
    Map<String, dynamic> signinMap = {
      "formFields": [
        {"id": "email", "value": ""},
        {"id": "password", "value": ""}
      ] // Leave this as an empty string initially
    };

    signinMap['formFields'][0]['value'] = email;
    signinMap['formFields'][1]['value'] = password;

    Map<String, dynamic> apiResponse = await apiService.post('auth/signin', signinMap);

    if (apiResponse['status'] == "FIELD_ERROR") {
      return {"status": "ERROR", "error": apiResponse["formFields"][0]["error"]};
    } else if (apiResponse['status'] == 'WRONG_CREDENTIALS_ERROR') {
      return {"status": "ERROR", "error": "The input email and password combination is incorrect."};
    } else if (apiResponse['status'] == "OK") {
      AuthBoxHelper.setIsAuthenticated(true);
      HiveService.setUser(User(userId: apiResponse["user"]["id"], username: "TEMP", email: "TEMP"));

      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  // Signup Function
  //
  static Future<Map<String, String>> signup(String email, String password, String username) async {
    Map<String, dynamic> signupMap = {
      "formFields": [
        {"id": "email", "value": "na"},
        {"id": "actualEmail", "value": ""},
        {"id": "username", "value": ""},
        {"id": "password", "value": ""}
      ] // Leave this as an empty string initially
    };

    signupMap['formFields'][1]['value'] = email;
    signupMap['formFields'][2]['value'] = username;
    signupMap['formFields'][3]['value'] = password;

    Map<String, dynamic> apiResponse = await apiService.post('auth/signup', signupMap);

    if (apiResponse['status'] == "FIELD_ERROR") {
      return {"status": "ERROR", "error": apiResponse["formFields"][0]["error"]};
    } else if (apiResponse['status'] == "OK") {
      AuthBoxHelper.setIsAuthenticated(true);
      HiveService.setUser(User(userId: apiResponse["user"]["id"], username: "TEMP", email: "TEMP"));

      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  // Check Auth of a user on app load
  //
  static Future<void> checkAuth() async {
    if (await SuperTokens.doesSessionExist()) {
      AuthBoxHelper.setIsAuthenticated(true);
    } else {
      AuthBoxHelper.setIsAuthenticated(false);
    }
  }

  // Call on Log out button press
  //
  static Future<void> signOut() async {
    await SuperTokens.signOut();

    HiveService.deleteUser();
    HiveService.deleteSettings();
    print(HiveService.getSettings().toString());
    AuthBoxHelper.setIsAuthenticated(false);
  }
}
