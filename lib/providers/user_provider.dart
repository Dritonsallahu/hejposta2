
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hejposta/local_storage/current_user_storage.dart';
import 'package:hejposta/models/client_model.dart';
import 'package:hejposta/models/postman_model.dart';
import 'package:hejposta/views/business/business_orders.dart';
import 'package:hejposta/views/postman/waiting_orders.dart';

class UserProvider extends ChangeNotifier{
  dynamic _user;

  getUser(){
    return _user;
  }

  removeUser (){
    _user = null;
    notifyListeners();
  }

  changeEmail(email){
    _user.user.email = email;
    notifyListeners();
  }

  addUser(String role, user,context){
    print(role);
    CurrentUserStorage currentUserStorage = CurrentUserStorage();
    currentUserStorage.addUser(user);
    if(role.toLowerCase() == "client"){
        _user = user as  ClientModel;
        notifyListeners();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const BusinessOrders()));
    }
    else if(role.toLowerCase() == "postman"){
        _user = user as PostmanModel;
        notifyListeners();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const WaitingOrders()));
    }
  }

  addPostmanAreas(areas){
    _user.areas.add(areas);
    print(_user.areas);
    notifyListeners();
  }

  addAllPostmanAreas(areas){
    _user.areas = areas;
    print(_user.areas);
    notifyListeners();
  }
}