import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/postman_model.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ZonesController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> getZones(context) async {
    print("geting zones");
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(zonesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    try {
      var response = await http.get(url, headers: _requestHeaders);
      print(response.body);
      var resBody = json.decode(response.body)['payload'];
      if (resBody.isNotEmpty) {
        List<Areas> arrAreas = [];
        for(int i=0;i<resBody.length;i++){
          arrAreas.add(Areas(id: resBody[i]['_id'],name: resBody[i]['name'],cityName: resBody[i]['cityName']));
        }
        user.addAllPostmanAreas(arrAreas);
        return "success";
      } else {
        return "success";
      }
    } catch (e) {
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
  }

  Future<String> deleteZone(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$deleteZoneUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    try {
      var response = await http.delete(url, headers: _requestHeaders);
      print(response.body);
      if(json.decode(response.body)['message'] == "success"){

        user.deletePostmanArea(id);
        return "success";
      }
      else{
        return "failed";
      }

    } catch (e) {
      return "Connection refused";
    }
  }
}
