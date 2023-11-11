import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/postman_order_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class PostmanOrdersController{

  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<void> getOrders(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    orderProvider.startFetchingPendingOrders();
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(pOrdersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    _requestHeaders['clients'] = user.getUser().clients.toString();
    _requestHeaders['cities'] = user.getUser().cities.toString();
    _requestHeaders['units'] = user.getUser().units.toString();
    try{
      var response = await http.get(url,headers: _requestHeaders);
      if(json.decode(response.body)['payload'].isNotEmpty){
        final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
        var o =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
        orderProvider.addOrders(o);
      }
      else{
        orderProvider.addOrders([]);
      }
    }catch(e){
      orderProvider.addOrders([]);

    }
    orderProvider.stopFetchingPendingOrders();
  }
  Future<void> getOnDeliveringOrders(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    orderProvider.startFetchingPendingOrders();
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(pOnDeliveringOrdersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    try{
      var response = await http.get(url,headers: _requestHeaders);
      if(json.decode(response.body)['payload'].isNotEmpty){
        final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
        var o =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
        orderProvider.addOnDeliveryOrders(o);
      }
      else{
        orderProvider.addOnDeliveryOrders([]);
      }
    }
    catch(e){
      return ;
    }

    orderProvider.addZone("all");
    orderProvider.stopFetchingPendingOrders();
  }

  Future<void> getOnEqualizeOrders(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    orderProvider.startFetchingPendingOrders();
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(pOnEqualizeOrdersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    var response = await http.get(url,headers: _requestHeaders);
    if(json.decode(response.body)['payload'].isNotEmpty){
      final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
      var o =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
      orderProvider.addOnDeliveryOrders(o);
    }
    else{
      orderProvider.addOnDeliveryOrders([]);
    }
    orderProvider.stopFetchingPendingOrders();
  }

  Future<String> pranoPorosine(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(pranoPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;

    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);

    if(body['message'] == "success"){
      return "success";
    }
    else if(body['message'] == "NotFound"){
      return "NotFound";
    }
    else if(body['message'] == "NotValid"){
      return "NotValid";
    }
    else{
      return body['message'];
    }
  }

  Future<String> dorzoNeDepoPorosine(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(dorezoNeDepoPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;

    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);
    if(body['message'] == "success"){
      return "success";
    }
    else if(body['message'] == "Not Found"){
      return "NotFound";
    }
    else{
      return body['message'];
    }
  }

  Future<String> refuzoPorosine(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(refuzoPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;

    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);
    if(body['message'] == "success"){
      return "success";
    }
    else if(body['message'] == "NotFound"){
      return "NotFound";
    }
    else if(body['message'] == "NotValid"){
      return "NotValid";
    }
    else{
      return "failed";
    }
  }

  Future<String> dergoTeKlientiPorosine(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(dergoTeKlientiPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;

    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);

    if(body['message'] == "success"){

      orderProvider.setOrderDelivered(id);
      return "success";
    }
    else if(body['message'] == "NotFound"){
      return "NotFound";
    }
    else if(body['message'] == "NotValid"){
      return "NotValid";
    }
    else{
      return body['message'];
    }
  }

  Future<String> refuzoNgaKlientiPorosine(context,id,reason,comment) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(refuzoNgaKlientiPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;
    map['arsyeja'] = reason;
    map['comment'] = comment.toString().isEmpty ? "": comment.toString();
    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);
  print(body);
    if(body['message'] == "success"){
      orderProvider.setOrderRejected(id);
      return "success";
    }
    else if(body['message'] == "NotFound"){
      return "NotFound";
    }
    else if(body['message'] == "NotValid"){
      return "NotValid";
    }
    else{
      return body['message'];
    }
  }

  Future<String> riktheNgaKlientiPorosine(context,id,reason,comment) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(riktheNgaKlientiPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;
    map['arsyeja'] = reason;
    map['comment'] = comment.toString().isEmpty ? "": comment.toString();
    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);
    if(body['message'] == "success"){
      orderProvider.setOrderReturned(id);
      return "success";
    }
    else if(body['message'] == "NotFound"){
      return "NotFound";
    }
    else if(body['message'] == "NotValid"){
      return "NotValid";
    }
    else{
      return body['message'];
    }
  }

  Future<String> ngarkoPorosinePerDergese(context,id,zone) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<PostmanOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(ngarkoPerDergeseUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;

    var map = <String, dynamic>{};
    map['order_number'] = id;
    map['postman'] = user.getUser().fullName;
    // map['zone'] = zone;
    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);
    print(body);
    if(body['status'] == "success"){
      orderProvider.setOrderLoaded(id);
      return "success";
    }
    else if(body['status'] == "NotFound"){
      return "NotFound";
    }
    else if(body['status'] == "NotValid"){
      return "NotValid";
    }
    else{
      return body['status'];
    }
  }


  Future<String> filterByZone(context,zone) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    var url = Uri.parse(dergoTeKlientiPorosineUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;


    var map = <String, dynamic>{};
    map['zone'] = zone;

    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    var body = jsonDecode(response.body);
    if(body['message'] == "success"){
      return "success";
    }
    else if(body['message'] == "NotFound"){
      return "NotFound";
    }
    else if(body['message'] == "NotValid"){
      return "NotValid";
    }
    else{
      return "failed";
    }
  }
}