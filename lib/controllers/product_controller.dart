import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/product_model.dart';
import 'package:hejposta/providers/product_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<dynamic> addProduct(context,productName,price,qty,desc,open,broke,change,{XFile? file}) async {
    var provider = Provider.of<ProductProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;



    if(file != null){
      // Create a new multipart request
      var url = Uri.parse(productsUrl);
      final request = http.MultipartRequest('POST', url);
      // Add the image file as a part of the request
      final fileStream = http.ByteStream(file!.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        'image', // This is the name of the field in your Node.js server that expects the image file
        fileStream,
        fileLength,
        filename: file.name,
      );
      request.files.add(multipartFile);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['user-id'] = user.getUser()!.clientId;

      request.fields['productName'] = productName;
      request.fields['price'] = price;
      request.fields['qty'] = qty;
      request.fields['describe'] = desc;
      request.fields['open'] = open.toString();
      request.fields['brake'] = broke.toString();
      request.fields['change'] = change.toString();

      // Send the request to your server
      final response = await request.send();
      print(response.statusCode);
// Check the response status code
      if (response.statusCode == 200) {
        // Success! The image has been uploaded to your server.
        print('Image uploaded successfully!');
        return "success";
      } else {
        // Something went wrong
        return "failed";
        print('Error uploading image. Status code: ${response.statusCode}');
      }
    }
    else{
      var url = Uri.parse(productsNoImageUrl);
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

  Future<dynamic> updateProduct(context,id,productName,price,qty,desc,open,broke,change,{XFile? file}) async {
    var provider = Provider.of<ProductProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    if(file != null){
      var url = Uri.parse("$productsUrl-update/$id");
      print(url);
      // Create a new multipart request
      final request = http.MultipartRequest('PUT', url);
      // Add the image file as a part of the request
      final fileStream = http.ByteStream(file!.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        'image', // This is the name of the field in your Node.js server that expects the image file
        fileStream,
        fileLength,
        filename: file.name,
      );
      request.files.add(multipartFile);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['user-id'] = user.getUser()!.clientId;

      request.fields['productName'] = productName;
      request.fields['price'] = price;
      request.fields['qty'] = qty;
      request.fields['describe'] = desc;
      request.fields['open'] = open.toString();
      request.fields['brake'] = broke.toString();
      request.fields['change'] = change.toString();

      // Send the request to your server
      final response = await request.send();
      print(response.statusCode);
// Check the response status code
      if (response.statusCode == 200) {
        // Success! The image has been uploaded to your server.
        print('Image uploaded successfully!');
        return "success";
      } else {
        // Something went wrong
        return "failed";
        print('Error uploading image. Status code: ${response.statusCode}');
      }
    }
    else{
      var url = Uri.parse("$productsUrl/$id");
      var bodyMap = <String, dynamic>{};
      bodyMap['productName'] = productName;
      bodyMap['price'] = price;
      bodyMap['qty'] = qty;
      bodyMap['describe'] = desc;
      bodyMap['open'] = open.toString();
      bodyMap['brake'] = broke.toString();
      bodyMap['change'] = change.toString();

      var response = await http.put(url,headers: _requestHeaders,body: jsonEncode(bodyMap));
      final body = json.decode(response.body);
      if(body['message'] == "success"){
        var product =   ProductModel.fromJson(body['payload']);
        provider.updateProduct(product);
        return "success";
      }
      else{
        return "failed";
      }
    }

  }

  Future<dynamic> deleteProduct(context,id,) async {
    var provider = Provider.of<ProductProvider>(context,listen: false);
    var user = Provider.of<UserProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$productsUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['user-id'] = user.getUser()!.clientId;

    var response = await http.delete(url,headers: _requestHeaders,);
    final body = json.decode(response.body);
    if(body['message'] == "success"){
        var product =   ProductModel.fromJson(body['payload']);
        provider.deleteProduct(product);
        return "success";
    }
    else{
      return "failed";
    }
  }
}