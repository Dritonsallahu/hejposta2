import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/product_model.dart';
import 'package:hejposta/providers/product_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class ProductController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getProducts(context) async {
    var productProvider = Provider.of<ProductProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100)).then((value) {
      productProvider.startFetching();
    });
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(productsUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    var response = await http.get(url,headers: _requestHeaders);
    final body = json.decode(response.body);
    if(response.statusCode == 200){
      if(body['message'] == "success"){
        if(body['payload'].length > 0){
          var products =  body['payload'].map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
          productProvider.addProducts(products);
        }
        else{
          productProvider.addProducts([]);
        }
      }
      else{
        return "failed";
      }
    }
    else{
      return "failed";
    }
    productProvider.stopFetching();
  }

  Future<dynamic> addProduct(context,productName,price,qty,desc,open,broke,change,{File? file}) async {
    var provider = Provider.of<ProductProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(productsUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;


    var bodyMap = <String, dynamic>{};
    bodyMap['productName'] = productName;
    bodyMap['price'] = price;
    bodyMap['qty'] = qty;
    bodyMap['describe'] = desc;
    bodyMap['open'] = open.toString();
    bodyMap['brake'] = broke.toString();
    bodyMap['change'] = change.toString();

    var response = await http.post(url,headers: _requestHeaders,body: jsonEncode(bodyMap));
    final body = json.decode(response.body);
    if(body['message'] == "success"){
        var product =   ProductModel.fromJson(body['payload']);
        provider.addProduct(product);
        return "success";
    }
    else{
      return "failed";
    }
  }
}