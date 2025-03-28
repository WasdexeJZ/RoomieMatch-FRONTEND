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

  static Future<Map<String, dynamic>> getAllProfile() async {
    Map<String, dynamic> apiResponse = await apiService.get('db/get-all-profile/');

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return apiResponse;
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> updateProfileField(String field, String value) async {
    Map<String, dynamic> profileMap = {"field": "", "value": ""};

    profileMap['field'] = field;
    profileMap['value'] = value;

    Map<String, dynamic> apiResponse = await apiService.post('db/update-profile/', profileMap);

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> updatePreferenceField(String field, String value) async {
    Map<String, dynamic> preferenceMap = {"field": "", "value": ""};

    preferenceMap['field'] = field;
    preferenceMap['value'] = value;

    Map<String, dynamic> apiResponse = await apiService.post('db/update-preference/', preferenceMap);

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
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

  static Future<Map<String, String>> updateMatch(String compareUserId, int currMatchType) async {
    Map<String, dynamic> matchMap = {"compare_user_id": "", "curr_match_type": 2};

    matchMap['compare_user_id'] = compareUserId;
    matchMap['curr_match_type'] = currMatchType;

    Map<String, dynamic> apiResponse = await apiService.post('db/update-match/', matchMap);

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, dynamic>> getStat(String userId, String key) async {
    Map<String, dynamic> apiResponse = await apiService.get('db/get-stat/?user_id=$userId&key=$key');

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return apiResponse;
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> updateStat(String userId, String key, String value) async {
    Map<String, dynamic> statMap = {"user_id": "", "key": "", "value": ""};

    statMap['user_id'] = userId;
    statMap['key'] = key;
    statMap['value'] = value;

    Map<String, dynamic> apiResponse = await apiService.post('db/update-stat/', statMap);

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> deleteStat(String userId, String key) async {
    Map<String, dynamic> apiResponse = await apiService.get('db/delete-stat/?user_id=$userId&key=$key');

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }

  static Future<Map<String, String>> triggerProcessMatch() async {
    Map<String, dynamic> apiResponse = await apiService.get('logic/process-match/');

    if (apiResponse['status'] == 'ERROR') {
      return {"status": "ERROR", "error": apiResponse["message"]};
    } else if (apiResponse['status'] == "OK") {
      return {"status": "OK"};
    } else {
      return {"status": "UNKNOWN"};
    }
  }
}
