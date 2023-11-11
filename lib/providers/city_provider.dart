import 'package:flutter/foundation.dart';
import 'package:hejposta/models/city_model.dart';

class CityProvier extends ChangeNotifier{
  final List<CityModel> _qytetet = [];

  List<CityModel> getCities() => _qytetet;

  Iterable<CityModel> getCitiesByState(state) => _qytetet.where((element) => element.state == state);
   CityModel  getCitiesById(id) => _qytetet.firstWhere((element) => element.id == id);

  addCities(List<CityModel> qytetet) {
    _qytetet.clear();
    _qytetet.addAll(qytetet);
    notifyListeners();
  }

  addCity(CityModel qyteti){
    _qytetet.add(qyteti);
    notifyListeners();
  }

  removeCity(){
    _qytetet.clear();
    notifyListeners();
  }


}