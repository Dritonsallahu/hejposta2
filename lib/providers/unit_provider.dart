import 'package:flutter/foundation.dart';
import 'package:hejposta/models/unit_model.dart'; 

class UnitProvider extends ChangeNotifier{
  final List<UnitModel> _units = [];

  List<UnitModel> getUnits() => _units;

  Iterable<UnitModel> getUnitsByClient(id) => _units.where((element) => element.client == id);

  addUnits(List<UnitModel> units) {
    _units.clear();
    _units.addAll(units);
    notifyListeners();
  }

  addUnit(UnitModel unit){
    _units.add(unit);
    notifyListeners();
  }

  removeUnit(){
    _units.clear();
    notifyListeners();
  }


}