import 'package:flutter/foundation.dart';
import 'package:hejposta/models/offer_model.dart';

class OfferProvider extends ChangeNotifier{
  final List<OfferModel> _offers = [];

  getOffers() => _offers;

  Iterable<OfferModel> getOfferByState(state) => _offers.where((element) => element.state == state);

  addOffers(List<OfferModel> offers) {
    _offers.clear();
    _offers.addAll(offers);
    notifyListeners();
  }

  addOffer(OfferModel offer){
    _offers.add(offer);
    notifyListeners();
  }

  removeOffer(){
    _offers.clear();
    notifyListeners();
  }


}