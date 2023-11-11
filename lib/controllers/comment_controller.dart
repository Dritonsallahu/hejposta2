import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/comment_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/modals.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class CommentController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> getAllComments(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(commentsUrl);
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var response = await http.get(url, headers: _requestHeaders);
    var bodyRes = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (bodyRes['message'] == "success") {
        final parsed = bodyRes['data'];
        var comments = parsed
            .map<CommentModel>((json) => CommentModel.fromJson(json))
            .toList();
        return comments;
      } else {
        return "failed";
      }
    } else {
      serverRespondErrorModal(context);
    }
  }
  Future<dynamic> getComments(context, orderId) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse("$commentsUrl/$orderId");
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var response = await http.get(url, headers: _requestHeaders);
    var bodyRes = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (bodyRes['message'] == "success") {
        final parsed = bodyRes['data'];
        var comments = parsed
            .map<CommentModel>((json) => CommentModel.fromJson(json))
            .toList();
        return comments;
      } else {
        return "failed";
      }
    } else {
      serverRespondErrorModal(context);
    }
  }

  Future<dynamic> addComment(context, OrderModel order, comment) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(commentsUrl);
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var map = <String, dynamic>{};
    map['comment'] = comment;
    map['order_id'] = order.id;
    map['sender'] = order.sender!.id;
    map['order_number'] = order.orderNumber;
    map['postman'] = order.deliveringPostman;
    var response = await http.post(url, headers: _requestHeaders, body: jsonEncode(map));


    var bodyRes = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (bodyRes['message'] == "success") {
        var commentModel = CommentModel.fromJson(bodyRes['data']);
        return commentModel;
      } else {
        return "failed";
      }
    } else {
      serverRespondErrorModal(context);
      return "error";
    }
  }
}
