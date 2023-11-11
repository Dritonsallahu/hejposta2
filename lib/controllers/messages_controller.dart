import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/message_model.dart';
import 'package:hejposta/providers/messages_provider.dart';
import 'package:hejposta/providers/server_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class MessagesController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getMessages(context) async {
    var messagesProvider = Provider.of<MessagesProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(messagesProfileUrl);AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['data'];
    print(parsed);
    messagesProvider.addAdmin(json.decode(response.body)['admin']);
    var messagesList =  parsed.map<MessageModel>((json) => MessageModel.fromJson(json)).toList();
    messagesProvider.addMessages(messagesList);
  }

  Future<dynamic> sendMessage(context, message) async {
    var messagesProvider = Provider.of<MessagesProvider>(context,listen: false);
    var serverProvider = Provider.of<ServerProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(messagesProfileUrl);
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");

    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.user.id;

    var mapBody  = <String, dynamic>{};
    mapBody['message'] = message;
    mapBody['to'] = message;
    mapBody['by'] = user.getUser()!.user.id;
    var response = await http.post(url,headers: _requestHeaders, body: jsonEncode(mapBody));
    var bodyRes = json.decode(response.body);
    if(bodyRes['message'] == "success"){
      serverProvider.sendMessage(bodyRes['data']['to'],bodyRes['data']['by'],message);
    }
    final parsed = json.decode(response.body)['data'];
    var messageObject =  MessageModel.fromJson(parsed);
    messagesProvider.addMessage(messageObject);
  }
}