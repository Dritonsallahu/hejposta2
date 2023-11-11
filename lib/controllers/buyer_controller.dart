import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/buyer_model.dart';
import 'package:hejposta/providers/buyer_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class BuyerController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getBuyer(context) async {
    var buyers = Provider.of<BuyerProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(buyersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['payload'];
    var buyersList =  parsed.map<BuyerModel>((json) => BuyerModel.fromJson(json)).toList();

    buyers.addBuyers(buyersList);
  }
  Future<dynamic> addBuyer(context,client, fullName, address, city, state, phoneNumber) async {
    var buyers = Provider.of<BuyerProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(buyersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    var bodyMap = <String, dynamic>{};
    bodyMap['client'] = user.getUser()!.clientId;
    bodyMap['fullName'] = fullName;
    bodyMap['address'] = address;
    bodyMap['city'] = city;
    bodyMap['state'] = state;
    bodyMap['phoneNumber'] = phoneNumber;

    var response = await http.post(url,headers: _requestHeaders,body: jsonEncode(bodyMap));
    var resBody = json.decode(response.body);
    if(resBody['message'] == "success"){
      final parsed = resBody['payload'];
      var buyerModel =   BuyerModel.fromJson(parsed);
      buyers.addBuyer(buyerModel);
      return "success";
    }
    else if(resBody['message'] == "failed"){
      return "Shtimi i blersit te ri deshtoi!";
    }
    else if(resBody['message'] == "exists"){
      return "Ky bleres tashme ekziston!";
    }
  }


}