import 'dart:convert';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/urls.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class RegistrationController{
  static Map<String, String> requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  static Future<dynamic> register(context,String username, String businessName,String shteti, String city,String address, phoneNumber,String email, String password,String referralCode) async{
    var url = Uri.parse(registerUrl);

    var mapBody = <dynamic, String>{};
    mapBody['username'] = username;
    mapBody['businessName'] = businessName;
    mapBody['state'] = shteti;
    mapBody['city'] = city;
    mapBody['address'] = address;
    mapBody['phoneNumber'] = phoneNumber;
    mapBody['email'] = email;
    mapBody['password'] = password;
    if(referralCode.toString().isNotEmpty){
      mapBody['referal_code'] = referralCode;
    }
    try{
      var response = await http.post(url,headers: requestHeaders, body: jsonEncode(mapBody));
      var bodyRes = jsonDecode(response.body);
      print(bodyRes);
      if(response.statusCode == 200){
        if(bodyRes['status'] == "success"){
          return "success";
        }
        else if(bodyRes['status'] == "failed"){
          return bodyRes['errors'];
        }
        else{
          return "failed";
        }
      }
      else{
        return "failed";
      }
    }catch(e){
      serverRespondErrorModal(context);
      return "0";
    }

  }
}