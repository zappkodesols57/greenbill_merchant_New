import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    String token;
    if (!_initialized) {
      _firebaseMessaging.requestPermission();
      _firebaseMessaging.app;

      // For iOS request permission first.

      // For testing purposes print the Firebase Messaging token
      token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      _initialized = true;
      sendToken(token);
    }
  }

  Future<void> sendToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final param = {
      "mobile_no": preferences.getString("mobile"),
      "device_id": token,
      "user_type": "merchant",
    };

    print("_________________$param");

    final response = await http.post(
        Uri.parse("http://157.230.228.250/store-device-id-api/"),
        body: param,
    );

    CommonData commonData;
    var responseJson = json.decode(response.body);
    commonData = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print(">>>>>>>>Push Notification<<<<<<<<<<");
      if(commonData.status == "success"){
        print(commonData.status);
        preferences.setString("isTokenSend", "yes");
      } else print(commonData.status);
    } else {
      print(commonData.status);
      return null;
    }
  }
}