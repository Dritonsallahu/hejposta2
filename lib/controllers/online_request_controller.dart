import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/comment_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/models/order_request_model.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/modals.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class OnlineRequestController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> getOnlineRequests(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(onlineRequestsUrl);
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['client-id'] = user.getUser()!.clientId;
    print(url);
    var response = await http.get(url, headers: _requestHeaders);
    var bodyRes = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      if (bodyRes['message'] == "success") {
        final parsed = bodyRes['data'];
        var orders = parsed
            .map<OrderRequestModel>((json) => OrderRequestModel.fromJson(json))
            .toList();
        return orders;
      } else {
        return "failed";
      }
    } else {
      serverRespondErrorModal(context);
    }
  }

  Future<dynamic> rejectRequest(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse("$onlineRequestsUrl/$id");
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['client-id'] = user.getUser()!.clientId;

    var response = await http.delete(url, headers: _requestHeaders);
    var bodyRes = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (bodyRes['message'] == "success") {

        return "success";
      } else {
        return "failed";
      }
    } else {
      serverRespondErrorModal(context);
    }
  }

  Future<dynamic> acceptRequest(context,id,name,price,status) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse("$onlineRequestsUrl/$id");
    AndroidOptions getAndroidOptions() => const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['client-id'] = user.getUser()!.clientId;

    var body = <String, dynamic>{};
    body['offerId'] = id;
    body['price'] = price;
    body['status'] = status;
    body['offerName'] = name;
    var response = await http.put(url, headers: _requestHeaders,body: jsonEncode(body));
    var bodyRes = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (bodyRes['message'] == "success") {
        return "success";
      } else {
        return "failed";
      }
    } else {
      serverRespondErrorModal(context);
    }
  }
}
