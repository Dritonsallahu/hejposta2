import 'package:flutter/foundation.dart';
import 'package:hejposta/models/expence_model.dart';

class ExpenceProvider extends ChangeNotifier{
  final List<ExpenceModel> _expences = [];
  bool isFetchingExpences = false;

  List<ExpenceModel> getExpences() => _expences;

  ExpenceModel  getExpencesById(id) => _expences.firstWhere((element) => element.id == id);

  addExpences(List<ExpenceModel> expences) {
    _expences.clear();
    _expences.addAll(expences);
    notifyListeners();
  }

  addExpence(ExpenceModel expenceModel){
    _expences.add(expenceModel);
    notifyListeners();
  }

  removeExpence(){
    _expences.clear();
    notifyListeners();
  }

  isFeching() => isFetchingExpences;

  startFetchingExpences(){
    isFetchingExpences = true;
  }

  stopFetchingExpences(){
    isFetchingExpences = false;
  }


}