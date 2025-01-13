import '../models/user.dart';
import './api_service.dart';
import '../stores/auth_store.dart';

class AuthService {
  final AuthStore authStore;
  final ApiService apiService = ApiService();

  Map<String, dynamic> authMap = {
    "formFields": [
      {
        "id": "email",
        "value": "" // Leave this as an empty string initially
      },
      {"id": "password", "value": ""}
    ]
  };

  AuthService(this.authStore);

  Future<Map<String, String>> login(String email, String password) async {
    authMap['formFields'][0]['value'] = email;
    authMap['formFields'][1]['value'] = password;

    print('Logging in with username: $email and password: $password');

    Map<String, dynamic> apiResponse = await apiService.post('auth/signin', authMap);

    if (apiResponse['status'] == "FIELD_ERROR") {
      return {"status": "ERROR", "error": apiResponse["formFields"][0]["error"]};
    } else if (apiResponse['status'] == 'WRONG_CREDENTIALS_ERROR') {
      return {"status": "ERROR", "error": "The input email and password combination is incorrect."};
    } else if (apiResponse['status'] == "OK") {
      authStore.setIsAuthenticated = true;
      authStore.setUser = User(id: apiResponse["user"]["id"], email: email);

      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  Future<Map<String, String>> signup(String email, String password, String username) async {
    authMap['formFields'][0]['value'] = email;
    authMap['formFields'][1]['value'] = password;

    print('Registering with username: $username, email: $email, and password: $password');

    Map<String, dynamic> apiResponse = await apiService.post('auth/signup', authMap);

    if (apiResponse['status'] == "FIELD_ERROR") {
      return {"status": "ERROR", "error": apiResponse["formFields"][0]["error"]};
    } else if (apiResponse['status'] == "OK") {
      authStore.setIsAuthenticated = true;
      authStore.setUser = User(id: apiResponse["user"]["id"], email: email);

      // call own create user funciton

      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }
}
