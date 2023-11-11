import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/client_model.dart';
import 'package:hejposta/models/postman_model.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginController {
  static Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  static Future<String?> authenticate(String username, String password,context) async {
    var userProvide = Provider.of<UserProvider>(context,listen: false);
    var url = Uri.parse(authUrl);
    print(authUrl);
    var mapBody = <dynamic, String>{};
    mapBody['email'] = username;
    mapBody['password'] = password;
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    try {
      var response = await http.post(url, headers: requestHeaders, body: jsonEncode(mapBody));

      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var token = data['token'];
        var user = data['user'];
        var role = data['role'];
        if (user != null) {
          await storage.write(key: "hejposta_2-token", value: token);
          final parsed = json.decode(response.body) ;
          if (role == "Client") {
            var user =  ClientModel.fromJson(parsed);
            userProvide.addUser("client", user,context);
            return "success";
          } else if (role == "Postman") {
            var user =  PostmanModel.fromJson(parsed);
            print(user);
            userProvide.addUser("postman", user,context);
            return "success";
          }
          else{
            return "Te dhenat jane gabim!";
          }
        }
        else if (data['status'] == "failed") {
          return data['message'];
        }
      } else {
        return "Ka ndodhur nje problem!\nJu lutem kontaktoni administraten.";
      }
    } catch (e) {
      return "Ka ndodhur nje problem!\nJu lutem kontaktoni administraten.";
    }
    return null;
  }
}
