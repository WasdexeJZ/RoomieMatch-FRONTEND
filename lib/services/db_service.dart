import './api_service.dart';

class DBService {
  static final ApiService apiService = ApiService();

  DBService();

  static Future<Map<String, dynamic>> getAllSettings() async {
    Map<String, dynamic> apiResponse = await apiService.get('db/get-all-settings/');

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return apiResponse;
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> updateSettingsField(String field, String value) async {
    Map<String, dynamic> settingsMap = {"field": "", "value": ""};

    settingsMap['field'] = field;
    settingsMap['value'] = value;

    Map<String, dynamic> apiResponse = await apiService.post('db/update-settings/', settingsMap);

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> updateProfileField(String email, String password) async {
    return {"status": "UNKNOWN"};
  }

  static Future<Map<String, dynamic>> getAllMatches() async {
    Map<String, dynamic> apiResponse = await apiService.get('db/get-all-matches/');

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return apiResponse;
    } else {
      return {"status": "UNKNOWN"};
    }
  }


 static Future<Map<String, String>> updateMatch(String compare_user_id, int curr_match_type) async {
    Map<String, dynamic> matchMap = {"compare_user_id": "", "curr_match_type": 2};

    matchMap['compare_user_id'] = compare_user_id;
    matchMap['curr_match_type'] = curr_match_type;

    Map<String, dynamic> apiResponse = await apiService.post('db/update-match/', matchMap);

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

}
