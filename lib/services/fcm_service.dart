import 'dart:convert';

import 'package:http/http.dart' as http;

class FCMService {
  static const String FCMAPI =
      "AAAA_3GyKVk:APA91bFc5hDDQ31aj-0fLaYx-O04WkOWkZrok4VgLJbqncYdMeEcDQ3Mol65-JnuNgf_kFld87fAZDVt_Awfx63TTGxZGPE13czu9fzKLzHgP8v6PR5Tegg78RcnfzXeetV8law542RO";
  static String makePayLoadWithToken(String? token, Map<String, dynamic> data,
      Map<String, dynamic> notification) {
    return jsonEncode({
      'to': token,
      'data': data,
      'notification': notification,
    });
  }

  static String makePayLoadWithTopic(String? topic, Map<String, dynamic> data,
      Map<String, dynamic> notification) {
    return jsonEncode({
      'topic': topic,
      'data': data,
      'notification': notification,
    });
  }

  static Future<void> sendPushMessage(String? token, Map<String, dynamic> data,
      Map<String, dynamic> notification) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$FCMAPI'
        },
        body: makePayLoadWithToken(token, data, notification),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }
}
