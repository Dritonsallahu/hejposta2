import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/order_history_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class ClientOrdersController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<void> getOrders(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    orderProvider.startFetchingPendingOrders();
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(ordersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().user.id;

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
    var o =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();

    for(int i=0;i<o.length;i++){

    }
    orderProvider.addOrders(o);
    orderProvider.stopFetchingPendingOrders();
  }

  Future<void> getOrdersByStatus(context,status) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: false);
    orderProvider.startFetchingPendingOrders();
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$ordersUrl/$status");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().id;

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
    var o =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
    orderProvider.addOrders(o);
    orderProvider.stopFetchingPendingOrders();
  }

  Future<String> newOrder(context,
  emriProduktit,
  blersi,
  shteti,
  qyteti,
  qmimi,
  sasia,
  oferta,
  unit,
  adresa,
  nrTel,
  pershkrimi,
  isOpen,
  isbrokable,
  isChange,
  productId,
      buyerId,
      ) async {

    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: false);
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(newOrderUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().clientId;
    var map = <String, dynamic>{};
    map['orderName'] = emriProduktit;
    map['fullName'] = blersi;
    map['state'] = shteti;
    map['city'] = qyteti;
    map['price'] = qmimi;
    map['sasia'] = sasia;
    map['offerId'] = oferta;
    map['unitId'] = unit;
    map['address'] = adresa;
    map['phoneNumber'] = nrTel;
    map['comment'] = pershkrimi;
    map['open'] = isOpen;
    map['broke'] = isbrokable;
    map['change'] = isChange;
    if(buyerId.toString().isNotEmpty){
      map['buyer'] = buyerId;
    }

    if(productId.toString().isNotEmpty){
      map['product'] = productId;
    }
    try{
      var response = await http.post(url,headers: _requestHeaders,body: jsonEncode(map));
      final data = json.decode(response.body)['data'];
      print(response.body);
      final message = json.decode(response.body)['message'];
      if(message == "success"){
        orderProvider.addOrder(OrderModel.fromJson(data));
        return "success";
      }
      else{
        return "failed";
      }
    }catch(e){
      print(e);
      return "false";
    }
  }

  Future<String> editOrder(context,
  emriProduktit,
  blersi,blersiId,
  shteti,
  qyteti,
  qmimi,
  sasia,
  oferta,
  unit,
  adresa,
  nrTel,
  pershkrimi,
  isOpen,
  isbrokable,
  isChange,
  productId,
      buyerId,
      orderId
      ) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: false);
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(editOrderUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().clientId;
    var map = <String, dynamic>{};
    map['orderName'] = emriProduktit;
    map['fullName'] = blersi;
    map['buyer'] = blersiId;
    print(blersiId);
    map['state'] = shteti;
    map['city'] = qyteti;
    map['price'] = qmimi;
    map['sasia'] = sasia;
    map['offerId'] = oferta;
    map['unitId'] = unit;
    map['address'] = adresa;
    map['phoneNumber'] = nrTel;
    map['comment'] = pershkrimi;
    map['open'] = isOpen;
    map['broke'] = isbrokable;
    map['change'] = isChange;
    map['orderId'] = orderId;
    if(buyerId.toString().isNotEmpty){
      map['buyer'] = buyerId;
    }
    if(productId.toString().isNotEmpty){
      map['product'] = productId;
    }
    var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(map));
    final message = json.decode(response.body)['status'];
    if(message == "success"){
      orderProvider.editOrder(OrderModel.fromJson(json.decode(response.body)['order']));
      return "success";
    }
    else{
      return "failed";
    }
  }

  Future<dynamic> getOrderHistory(context,id) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$orderHistoryUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['order-id'] = id;

    var response = await http.get(url,headers: _requestHeaders);
    if(response.statusCode == 200){
      if(json.decode(response.body)['payload'] == "empty"){
        return "empty";
      }
      else{
        return OrderHistoryModel.fromJson(json.decode(response.body)['payload']) ;
      }

    }
    else{
      return "Something went wrong";
    }

  }

  Future<dynamic> deleteOrder(context,id) async {
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: false);
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$deleteOrderUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";

    var response = await http.delete(url,headers: _requestHeaders);
    if(response.statusCode == 200){
      if(json.decode(response.body)['message'] == "success"){
        orderProvider.deleteOrderById(id);
        return "success"; }
      else { return "Failed"; }
    }
    else{ return "Something went wrong"; }

  }
}