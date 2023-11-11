import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/expence_model.dart';
import 'package:hejposta/models/postman_model.dart';
import 'package:hejposta/providers/expence_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ZonesController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> getZones(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(zonesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    print("---");
    try {
      var response = await http.get(url, headers: _requestHeaders);
      var resBody = json.decode(response.body)['payload'];
      if (resBody.isNotEmpty) {
        print(resBody);
        List<Areas> arrAreas = [];
        for(int i=0;i<resBody.length;i++){
          arrAreas.add(Areas(name: resBody[i]['name'],cityName: resBody[i]['cityName']));
        }
        user.addAllPostmanAreas(arrAreas);
        return "success";
      } else {
        return "success";
      }
    } catch (e) {
      print(e);
      return "Connection refused";
    }
  }

  Future<String> addZone(context,String name,String cityName) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(zonesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['name'] =name;
    map['cityName'] = cityName;

    try {
      var response = await http.put(url, headers: _requestHeaders, body: jsonEncode(map));
      if(json.decode(response.body)['message'] == "success"){
        var ar = Areas(name: map['name'],cityName:map['cityName']);
        user.addPostmanAreas(ar);
        return "success";
      }
      else{
        return "failed";
      }

    } catch (e) {
      return "Connection refused";
    }
    return "sd";
  }
}
