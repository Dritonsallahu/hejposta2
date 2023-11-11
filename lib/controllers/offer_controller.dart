import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/models/city_model.dart';
import 'package:hejposta/models/offer_model.dart';
import 'package:hejposta/models/order_model.dart';
import 'package:hejposta/providers/city_provider.dart';
import 'package:hejposta/providers/client_order_provider.dart';
import 'package:hejposta/providers/offer_provider.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class OfferController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getOffers(context) async {
    var offers = Provider.of<OfferProvider>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    var token = await storage.read(key: "hejposta_2-token");
    var url = Uri.parse(offersUrl);
    _requestHeaders['Authorization'] = "Bearer $token";

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['data'];
    print(parsed);
    var offersList =  parsed.map<OfferModel>((json) => OfferModel.fromJson(json)).toList();
    offers.addOffers(offersList);
  }


}