import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/expence_model.dart';
import 'package:hejposta/providers/expence_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class ExpencesController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> getExpences(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var expence = Provider.of<ExpenceProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    expence.startFetchingExpences();
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(expencesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    try {
      var response = await http.get(url, headers: _requestHeaders);
      print(response.body);
      if (json.decode(response.body)['payload'].isNotEmpty) {
        final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
        var o = parsed.map<ExpenceModel>((json) => ExpenceModel.fromJson(json)).toList();
        expence.addExpences(o);
        return "success";
      } else {
        expence.addExpences([]);
        return "success";
      }
    } catch (e) {
      print(e);
      return "Connection refused";
    }
  }

  Future<String> addExpence(context,DateTime date, kategoria, qmimi, {File? document}) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var expence = Provider.of<ExpenceProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    expence.startFetchingExpences();
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(expencesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['expenceDate'] = date.toIso8601String();
    map['reason'] = kategoria.toString(); 
    map['total'] = qmimi.toString();
    try {
      var response = await http.post(url, headers: _requestHeaders, body: jsonEncode(map));
      print(response.body);
      if(json.decode(response.body)['message'] == "success"){
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
