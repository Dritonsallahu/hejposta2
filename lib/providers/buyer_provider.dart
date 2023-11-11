import 'package:flutter/foundation.dart';
import 'package:hejposta/models/buyer_model.dart';

class BuyerProvider extends ChangeNotifier{
    List<BuyerModel> _buyers = [];
  final List<BuyerModel> _buyersFilter = [];

  List<BuyerModel> getBuyers() => _buyers;


  addBuyers(List<BuyerModel> buyers) {
    _buyers.clear();
    _buyersFilter.clear();

    _buyers.addAll(buyers);
    _buyersFilter.addAll(buyers);
    notifyListeners();
  }

  addBuyer(BuyerModel buyer){
    _buyers.add(buyer);
    _buyersFilter.add(buyer);
    notifyListeners();
  }

  removeBuyer(){
    _buyers.clear();
    notifyListeners();
  }
  getCheckStatus(prId) => _buyers.firstWhere((element) => element.id == prId).checked;

  setCheck(prodId,status){
    for (var element in _buyers) {
      if(element.id == prodId){
        element.checked = status;
      }
      else{
        if(status){
          element.checked = false;
        }
      }
    }
    for (var element in _buyers) {
      if(element.id == prodId){
        element.checked = status;
      }
      else{
        if(status){
          element.checked = false;
        }
      }
    }
    notifyListeners();
  }
  filtro(emri) {
    _buyers = [];

    for (int i = 0; i < _buyersFilter.length; i++) {
      if (_buyersFilter[i]
          .fullName!
          .toUpperCase()
          .contains(emri.toUpperCase())) {
        _buyers.add(_buyersFilter[i]);
      }
    }
    notifyListeners();
  }
}