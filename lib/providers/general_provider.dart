import 'package:flutter/foundation.dart';

class GeneralProvider extends ChangeNotifier {
  bool isDrawerOpen = false;
  bool isCurrentColorGreen = false;

  checkDrawerStatus() => isDrawerOpen;

  isColorGreen() => isCurrentColorGreen;

  changeDrawerStatus(bool status){
    isDrawerOpen = status;
    notifyListeners();
  }
  setDrawerFalse(){
    isDrawerOpen = false;
    notifyListeners();
  }

  changeCurrentColor(bool status){
    isCurrentColorGreen = status;
    notifyListeners();
  }

}