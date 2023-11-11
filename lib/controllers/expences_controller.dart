import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/expence_model.dart';
import 'package:hejposta/providers/expence_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/shortcuts/modals.dart';
import 'package:hejposta/shortcuts/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ExpencesController {
  final _requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<String> getExpences(context) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var expence = Provider.of<ExpenceProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    expence.startFetchingExpences();
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(expencesUrl);
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    try {
      var response = await http.get(url, headers: _requestHeaders);
      if (json.decode(response.body)['payload'].isNotEmpty) {
        final parsed =
            json.decode(response.body)['payload'].cast<Map<String, dynamic>>();
        var o = parsed
            .map<ExpenceModel>((json) => ExpenceModel.fromJson(json))
            .toList();
        expence.addExpences(o);
        return "success";
      } else {
        expence.addExpences([]);
        return "success";
      }
    } catch (e) {
      return "Connection refused";
    }
  }

  Future<String> addExpence(context, DateTime date, kategoria, qmimi,
      {XFile? document}) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var expence = Provider.of<ExpenceProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    expence.startFetchingExpences();
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    if (document != null) {
      var url = Uri.parse(expencesWithImageUrl);
      // Create a new multipart request
      final request = http.MultipartRequest('POST', url);
      // Add the image file as a part of the request
      final fileStream = http.ByteStream(document!.openRead());
      final fileLength = await document.length();
      final multipartFile = http.MultipartFile(
        'image', // This is the name of the field in your Node.js server that expects the image file
        fileStream,
        fileLength,
        filename: document.name,
      );
      request.files.add(multipartFile);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['user-id'] = user.getUser()!.postmanId;

      request.fields['expenceDate'] = date.toIso8601String();
      request.fields['reason'] = kategoria.toString();
      request.fields['total'] = qmimi.toString();

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
    } else {
      var url = Uri.parse(expencesUrl);
      var map = <String, dynamic>{};
      map['expenceDate'] = date.toIso8601String();
      map['reason'] = kategoria.toString();
      map['total'] = qmimi.toString();
      try {
        var response = await http.post(url,
            headers: _requestHeaders, body: jsonEncode(map));
        if (json.decode(response.body)['message'] == "success") {
          return "success";
        } else {
          return "failed";
        }
      } catch (e) {
        return "Connection refused";
      }
    }
  }

  Future<String> deleteExpence(context,id) async {
    var user = Provider.of<UserProvider>(context, listen: false);
    var expence = Provider.of<ExpenceProvider>(context, listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    expence.startFetchingExpences();
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse("$expencesUrl/$id");
    _requestHeaders['Authorization'] = "Bearer $token";
    _requestHeaders['User-ID'] = user.getUser().postmanId;
    try {
      var response = await http.delete(url, headers: _requestHeaders);
      if (json.decode(response.body)['message'] == "success") {
        return "success";
      }
      else{
        return "failed";
      }
    } catch (e) {
      serverRespondErrorModal(context);
      return "Connection refused";
    }
  }
}
