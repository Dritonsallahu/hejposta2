import 'dart:convert';
import 'package:hejposta/models/city_model.dart';
import 'package:hejposta/providers/city_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:hejposta/shortcuts/urls.dart';
import 'package:provider/provider.dart';

class CityController {
  final _requestHeaders = { 'Content-type': 'application/json', 'Accept': 'application/json', };

  Future<dynamic> getQytetet(context) async {
    var qytetet = Provider.of<CityProvier>(context,listen: false);
    await Future.delayed(const Duration(milliseconds: 100));
    var url = Uri.parse(qytetetUrl);

    var response = await http.get(url,headers: _requestHeaders);
    final parsed = json.decode(response.body)['data'];
    var cities =  parsed.map<CityModel>((json) => CityModel.fromJson(json)).toList();

    qytetet.addCities(cities);
  }


}