import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class FinanceController{

  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getFinances(context,date) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(financesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    String formattedDate = date.toUtc().toIso8601String();
    _requestHeaders['date'] = formattedDate;
    try{
      var response = await http.get(url,headers: _requestHeaders);
      var bodyRes = jsonDecode(response.body);
      print(bodyRes);
      if(bodyRes['message'] == "success"){
        return bodyRes;
      }
      else{
        return "failed";
      }
    }catch(e){
      return "Connection Refused";
    }
  }
  Future<dynamic> getStatistikat(context,date) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(statisticsUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    String formattedDate = date.toUtc().toIso8601String();
    _requestHeaders['date'] = formattedDate;

      var response = await http.get(url,headers: _requestHeaders);
      var bodyRes = jsonDecode(response.body);
      if(bodyRes['message'] == "success"){
        // equalizationProvider.addEqualizations(equalizations);
        return bodyRes;
      }
      else{
        return "failed";
      }

  }
}