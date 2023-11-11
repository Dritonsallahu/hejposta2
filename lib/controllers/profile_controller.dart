import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/local_storage/current_user_storage.dart';
import 'package:hejposta/providers/general_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:hejposta/views/authentication.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ProfileController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> getProfile(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(postmanProfileUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.postmanId;

    var response = await http.get(url, headers: _requestHeaders);
    var bodyRes = jsonDecode(response.body);

    if (bodyRes['message'] == "success") {
      return bodyRes['payload'];
    }
  }

  Future<dynamic> updateProfile(context, username, oldPassword,newPassword,
      {String? email}) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(postmanProfileUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var map = <String, dynamic>{};
    map['username'] = username;
    if (email != null) { map['email'] = email; }
    map['oldPassword'] = oldPassword;
    map['newPassword'] = newPassword;
    var response = await http.put(url, headers: _requestHeaders,body: jsonEncode(map));
    var bodyRes = jsonDecode(response.body);
    if (bodyRes['message'] == "success") {
      return "success";
    }
    else{
      return bodyRes['message'];
    }
  }

  Future<dynamic> deleteAccount(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(removePostmanAccountUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var response = await http.put(url, headers: _requestHeaders);
    var bodyRes = jsonDecode(response.body);
    if (bodyRes['message'] == "success") {
      var drawer = Provider.of<GeneralProvider>(context,listen: false);
      drawer.setDrawerFalse();
      CurrentUserStorage currentUserStorage = CurrentUserStorage();
      currentUserStorage.removeUser(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const Authentication()), (route) => false);
      return "success";
    }
    else{
      return bodyRes['message'];
    }
  }
}
