import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/local_storage/current_user_storage.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenController {
  static String token = "";
  String appName = "NetworkClinic";
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  checkTokenStatus(context) {
    var profile = Provider.of<UserProvider>(context, listen: false);
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BIXmjhXgPxb1hDmrzWi5X7nJoMtzm59SW0sg7lCUz7QZir21G17VI96X1I4AkcPjWIYO6K1fTG2QJ_cn23wi41E')
        .then((value) {
      setToken(value!, profile);
    });
  }

  void setToken(String token, profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var oldToken = prefs.getString("hejposta_2-fcm-token");
    token = token;

    CurrentUserStorage localStorageData = CurrentUserStorage();
    if (prefs.getString("hejposta_2-fcm-token") != null && oldToken == token) {
      if (kDebugMode) {
        print("old: $oldToken");
        print("new: $token");
        print(
            "=================================================================================================================================================");
      }
    } else {
    if(kDebugMode){
      print("setting new token");
    }
      updateToken(token, profile);
      localStorageData.setToken(token);
    }
  }

  updateToken(String fcmToken, UserProvider profile) async {
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    try {
      final Uri rootUrl = Uri.parse(fcmTokenUrl);
      var map = <String, dynamic>{};

      _requestHeaders['Authorization'] = "Bearer $token";
      _requestHeaders['fcm-token'] = fcmToken;
      _requestHeaders['User-ID'] = profile.getUser().user.id;

      final response = await http.put(rootUrl, headers: _requestHeaders, body: jsonEncode(map));

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['message'] == "success") {
        } else {
        }
      } else {
      }
    } catch (e) {
      if(kDebugMode){
        print(e);
      }
    }
  }

  removeToken() {
    FirebaseMessaging.instance.deleteToken().then((value) {
    });
  }
}
