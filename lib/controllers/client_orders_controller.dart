import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/order_history_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/city_provider.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
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
    print(response.body);
    final parsed = json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
    var o =  parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
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
    var qytetet = Provider.of<CityProvier>(context, listen: false);
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
    if(productId.toString().isNotEmpty){
      map['buyer'] = buyerId;
    }
    if(productId.toString().isNotEmpty){
      map['product'] = productId;
    }
    var response = await http.post(url,headers: _requestHeaders,body: jsonEncode(map));
    print(response.body);
    final data = json.decode(response.body)['data'];
    final message = json.decode(response.body)['message'];
    if(message == "success"){
      orderProvider.addOrder(OrderModel.fromJson(data));
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
}