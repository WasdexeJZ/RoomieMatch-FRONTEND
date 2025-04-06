import 'package:intl/intl.dart';

import './api_service.dart';
import './chat_db_service.dart';
import './message_db_service.dart';

import '../helpers/auth_box_helper.dart';

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
    Map<String, dynamic> matchMap = {"compareUserId": "", "currMatchType": 2};

    matchMap['compareUserId'] = compareUserId;
    matchMap['currMatchType'] = currMatchType;

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
    Map<String, dynamic> statMap = {"userId": "", "key": "", "value": ""};

    statMap['userId'] = userId;
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

  static Future<void> getAllChats() async {
    Map<String, dynamic> apiResponse = await apiService.get('messaging/get-all-chats/');

    if (apiResponse['status'] == "OK") {
      for (int i = 0; i < apiResponse['matched'].length; i++) {
        await ChatDBService().insertChat(apiResponse['matched'][i]["userId"], apiResponse['matched'][i]["chatUserId"], apiResponse['matched'][i]['firstName'], apiResponse['matched'][i]["latestTime"].toInt());
      }
    }
  }

  static Future<List<Map<String, dynamic>>> getAllMessages() async {
    getAllChats();

    Map<String, dynamic> apiResponse = await apiService.get('messaging/get-messages/');
    String currUserId = AuthBoxHelper.getUserId();
    List<Map<String, dynamic>> result = [];

    if (apiResponse['status'] == "OK") {
      for (int i = 0; i < apiResponse['messages'].length; i++) {
        //
        //
        // Do decryption later here
        await MessageDBService().insertMessage(apiResponse['messages'][i]["senderUserId"], currUserId, apiResponse['messages'][i]['cipherText'], apiResponse['messages'][i]["timestamp"]);
        result.add({
          "senderUserId": apiResponse['messages'][i]["senderUserId"],
          "plainText": apiResponse['messages'][i]['cipherText'],
          "timestamp": apiResponse['messages'][i]["timestamp"],
        });

      }
    }

    return result;
  }

  static Future<void> sendMessage(String recipientUserId, String plainText) async {
    String cipherText = plainText;
    int keyId = 0;

//
//
// Do encryption later here
// Get public key also

    Map<String, dynamic> messageMap = {"recipientUserId": "", "cipherText": "", "keyId": -1};

    messageMap['recipientUserId'] = recipientUserId;
    messageMap['cipherText'] = cipherText;
    messageMap['keyId'] = keyId;

    String apiResponseStatus;
    bool isIteration = false;

    do {
      Map<String, dynamic> apiResponse = await apiService.post('messaging/send-messages/', messageMap);

      apiResponseStatus = apiResponse['status'];

      if (isIteration) {
        await Future.delayed(Duration(seconds: 30));
      }

      isIteration = true;
    } while (apiResponseStatus == 'ERROR' || apiResponseStatus == 'UNKNOWN');

    String currUserId = AuthBoxHelper.getUserId();
    String timestamp = DateFormat('yyyy-MM-ddTHH:mm:SS').format(DateTime.now()).toString();

    await MessageDBService().insertMessage(currUserId, recipientUserId, plainText, timestamp);
  }
}
