import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ClientFinanceController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> getFinances(context, date) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(financeProfileUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['Client-ID'] = user.getUser().clientId;
    _requestHeaders['User-ID'] = user.getUser().user.id;
    String formattedDate = date.toUtc().toIso8601String();
    _requestHeaders['date'] = formattedDate;

    var response = await http.get(url, headers: _requestHeaders);
    var bodyMap = jsonDecode(response.body);
    if (bodyMap['message'] == "success") {
      final parsed = bodyMap['ordersList'].cast<Map<String, dynamic>>();
      var ordersList = parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
      return {
        "total": bodyMap['totalOrders'],
        "ordersList": ordersList,
      };
    } else {
      return "failed";
    }
  }

  Future<List<OrderModel>> getStatistics(context, firstDate, lastDate, type, state) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var orderProvider = Provider.of<ClientOrderProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(statisticsProfileUrl);
    String formattedDate = firstDate.toUtc().toIso8601String();
    String formattedDate2 = lastDate.toUtc().toIso8601String();
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['Client-ID'] = user.getUser().clientId;
    _requestHeaders['User-ID'] = user.getUser().user.id;
    _requestHeaders['a-f'] = formattedDate;
    _requestHeaders['e-l'] = formattedDate2;

    _requestHeaders['type'] = type;

    if (state != "Te gjitha") {
      _requestHeaders['state'] = Uri.encodeComponent(state);
    }
    var response = await http.get(url, headers: _requestHeaders);
    var bodyMap = jsonDecode(response.body);

    if (bodyMap['message'] == "success") {
      final parsed = bodyMap['orders'].cast<Map<String, dynamic>>();
      var ordersList = parsed.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
      orderProvider.addOrders(ordersList);
      return ordersList;
    } else {
      return [];
    }
  }
}
