import 'dart:convert';

import 'package:hejposta/shortcuts/urls.dart';
import 'package:http/http.dart' as http;
class RegistrationController{
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static Future<void> register(String fullName, String businessName, String city,String address,String username, String password) async{
    var url = Uri.parse(registerUrl);

    var mapBody = <dynamic, String>{};
    mapBody['fullName'] = fullName;
    mapBody['businessName'] = businessName;
    mapBody['city'] = city;
    mapBody['address'] = address;
    mapBody['username'] = username;
    mapBody['password'] = password;
    var response = await http.post(url,headers: requestHeaders, body: jsonEncode(mapBody));

  }
}