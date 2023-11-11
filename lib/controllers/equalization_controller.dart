import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/equalization_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class EqualizationController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getEqualization(context) async {
    var equalization = Provider.of<EqualizationProvier>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(equalizationUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.postmanId;

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['payload'];
    print(parsed);
    var equalizations =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
    equalization.addEqualizations(equalizations);
  }

  Future<dynamic> getEqualizedOrders(context) async {
    var equalization = Provider.of<EqualizedOrdersProvier>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(equalizedUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.postmanId;

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['payload'];
    var equalizations =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();

    equalization.addEqualizations(equalizations);
  }
  Future<dynamic> performEqualization(context, equalCode) async {
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(performEqualizaiton);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.postmanId;
    _requestHeaders['equal-number'] = equalCode;

    var response = await http.put(url,headers: _requestHeaders);
    var res = jsonDecode(response.body);

    if(response.statusCode == 200){
      if(res['message'] == "success"){
        return "Klienti u barazua me sukses";
      }
      else{
        return res['message'];
      }

    }
    else{
      return "Barazimi i klientit deshtoi!";
    }
  }


}