import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/goal_model.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/modals.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class GoalsController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getGoals(context) async {
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(challengesProfileUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    try{
      var response = await http.get(url,headers: _requestHeaders);
      var bodyRes = json.decode(response.body);
      if(bodyRes['message'] == "success"){
        final parsed = bodyRes['payload'];
        var goalsList =  parsed.map<GoalModel>((json) => GoalModel.fromJson(json)).toList();
        return goalsList;
      }
      else {
        return "failed";
      }
    }catch(e){
      serverRespondErrorModal(context);
    }
  }
  Future<dynamic> addGoal(context,startDate,endDate,orderNumber) async {
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(challengeProfileUrl);
    String firstDateFormat = startDate.toUtc().toIso8601String();
    String secondDateFormat = endDate.toUtc().toIso8601String();
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    var mapBody = <String, dynamic>{};
    mapBody['startDate'] = firstDateFormat;
    mapBody['endDate'] = secondDateFormat;
    mapBody['orderNumber'] = int.parse(orderNumber);

    try{
      var response = await http.post(url,headers: _requestHeaders,body: jsonEncode(mapBody));
      var bodyRes = json.decode(response.body);
      developer.log("Message returned: $bodyRes");
      if(bodyRes['message'] == "success"){
        return "success";
      }
      else if(bodyRes['message'] == "exist"){
        return "exist";
      }
      else {
        return "failed";
      }
    }catch(e){
      serverRespondErrorModal(context);
    }
  }

  Future<dynamic> deleteGoal(context,id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$challengeProfileUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";

    try{
      var response = await http.delete(url,headers: _requestHeaders);
      var bodyRes = json.decode(response.body);
      if(bodyRes['message'] == "success"){
        return "success";
      }
      else {
        return "failed";
      }
    }catch(e){
      serverRespondErrorModal(context);
    }
  }

  Future<dynamic> completeGoal(context,id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$challengeProfileUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";
    try{
      var response = await http.put(url,headers: _requestHeaders);
      var bodyRes = json.decode(response.body);
      if(bodyRes['message'] == "success"){
        return "success";
      }
      else {
        return "failed";
      }
    }catch(e){
      serverRespondErrorModal(context);
    }
  }
}