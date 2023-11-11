import 'dart:convert';
import 'package:hejposta/shortcuts/modals.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';

class RulesController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getRules(context,user) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(rulesUrl);
    _requestHeaders['username'] = user;
    try{
      var response = await http.get(url,headers: _requestHeaders);
      final bodyRes = json.decode(response.body);
      print(bodyRes);
      if(bodyRes['message'] == "success"){
        return bodyRes['body'];
      }
      else {
        return "failed";
      }
    }catch(e){
      serverRespondErrorModal(context);
    }
  }


}