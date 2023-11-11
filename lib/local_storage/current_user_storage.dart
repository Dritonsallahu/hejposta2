import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejposta/controllers/token_controller.dart';
import 'package:hejposta/models/client_model.dart';
import 'package:hejposta/models/postman_model.dart';
import 'package:hejposta/models/user_model.dart';
import 'package:hejposta/providers/user_provider.dart';
import 'package:hejposta/views/authentication.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentUserStorage{

  Future<bool>? checkUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("hejposta_2-user")!;
  }

  addUser(dynamic user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("hejposta_2-user", true);
    if(user.user.role == "Client"){
      preferences.  setBool("hejposta_2-client-user" , true);
      // Adding super user
      preferences.setString("hejposta_2-user-id", user.user.id.toString());
      preferences.setString("hejposta_2-user-role", user.user.role);
      preferences.setString("hejposta_2-user-image", user.user.image ?? "");
      preferences.setString("hejposta_2-user-email", user.user.email);
      preferences.setString("hejposta_2-user-username", user.user.username);
      preferences.setString("hejposta_2-user-password", user.user.password);
      preferences.setBool("hejposta_2-user-isActive", user.user.isActive);
      preferences.setString("hejposta_2-user-createdAt", user.user.createdAt);
      preferences.setString("hejposta_2-user-updatedAt", user.user.updatedAt);

      // Adding client user
      preferences.setString("hejposta_2-client-id", user.clientId.toString());
      preferences.setString("hejposta_2-client-state", user.state);
      preferences.setString("hejposta_2-user-businessName", user.businessName);
      preferences.setString("hejposta_2-client-cityId", user.city['_id']);
      preferences.setString("hejposta_2-client-cityName", user.city['name']);
      preferences.setString("hejposta_2-client-address", user.address);
      preferences.setString("hejposta_2-client-billAddress", user.billAddress);
      preferences.setString("hejposta_2-client-phoneNumber", user.phoneNumber);
      preferences.setString("hejposta_2-client-comment", user.comment);
      preferences.setString("hejposta_2-client-status", user.status);
      preferences.setBool("hejposta_2-client-hasPosted", user.hasPosted);
      preferences.setString("hejposta_2-client-createdAt", user.createdAt);
      preferences.setString("hejposta_2-client-updatedAt", user.updatedAt);
    }
    else if(user.user.role == "Postman"){
      preferences.setBool("hejposta_2-postman-user" , true);
      // Adding super user
      preferences.setString("hejposta_2-user-id", user.user.id.toString());
      preferences.setString("hejposta_2-user-role", user.user.role);
      preferences.setString("hejposta_2-user-image", user.user.image);
      preferences.setString("hejposta_2-user-email", user.user.email ?? "");
      preferences.setString("hejposta_2-user-username", user.user.username);
      preferences.setString("hejposta_2-user-password", user.user.password);
      preferences.setBool("hejposta_2-user-isActive", user.user.isActive);
      preferences.setString("hejposta_2-user-createdAt", user.user.createdAt);
      preferences.setString("hejposta_2-user-updatedAt", user.user.updatedAt);

      // Adding postman user
      preferences.setString("hejposta_2-id", user.postmanId.toString());
      preferences.setString("hejposta_2-fullName", user.fullName);
      preferences.setInt("hejposta_2-salary", user.salary);
      preferences.setDouble("hejposta_2-onSuccessDeliveryBonus", user.onSuccessDeliveryBonus.toDouble());
      preferences.setString("hejposta_2-note", user.note);
      preferences.setString("hejposta_2-phoneNumber", user.phoneNumber);


      List<String> clientList = [];
      for(int i=0;i<user.clients.length;i++){
        clientList.add(user.clients[i]);
      }
      preferences.setStringList("hejposta_2-clients", clientList);

      List<String> citiesList = [];
      for(int i=0;i<user.cities.length;i++){
        citiesList.add(user.cities[i]);
      }
      preferences.setStringList("hejposta_2-cities", citiesList);

      List<String> unitsList = [];
      for(int i=0;i<user.units.length;i++){
        unitsList.add(user.units[i]);
      }
      preferences.setStringList("hejposta_2-units", unitsList);



    }
  }

  getUser(context) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var role = preferences.getString("hejposta_2-user-role");
    if(role == "Client"){

      preferences.  setBool("hejposta_2-client-user" , true);
      // Adding super user
      var id = preferences.getString("hejposta_2-user-id");
      var role = preferences.getString("hejposta_2-user-role");
      var image = preferences.getString("hejposta_2-user-image");
      var email = preferences.getString("hejposta_2-user-email");
      var username = preferences.getString("hejposta_2-user-username");
      var password = preferences.getString("hejposta_2-user-password");
      var isActive = preferences.  getBool("hejposta_2-user-isActive");
      var createdAt = preferences.getString("hejposta_2-user-createdAt");
      var updatedAt = preferences.getString("hejposta_2-user-updatedAt");

      // Adding client user
      var clientId = preferences.getString("hejposta_2-client-id");
      var state = preferences.getString("hejposta_2-client-state");
      var cityId = preferences.getString("hejposta_2-client-cityId");
      var cityName = preferences.getString("hejposta_2-client-cityName");
      var address = preferences.getString("hejposta_2-client-address");
      var businessName = preferences.getString("hejposta_2-user-businessName");
      var billAddress = preferences.getString("hejposta_2-client-billAddress");
      var phoneNumber = preferences.getString("hejposta_2-client-phoneNumber");
      var comment = preferences.getString("hejposta_2-client-comment");
      var status = preferences.getString("hejposta_2-client-status");
      var hasPosted = preferences.  getBool("hejposta_2-client-hasPosted");

      var user = UserModel(
          id: id,
          role: role,
          image: image,
          email: email,
          username: username,
          password: password,
          isActive: isActive,
          createdAt: createdAt,
          updatedAt: updatedAt,
      );
      var client = ClientModel(
        clientId: clientId,
          state: state,user: user,
          city: {"_id": cityId, "name": cityName},
          address: address,
          businessName: businessName,
          billAddress: billAddress,
          phoneNumber: phoneNumber,
          comment: comment,
          status: status,
          hasPosted: hasPosted,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      userProvider.addUser(role!, client, context);

    }
    else if(role == "Postman"){

      preferences.  setBool("hejposta_2-postman-user" , true);
      // Adding super user
      var id = preferences.getString("hejposta_2-user-id");
      var role = preferences.getString("hejposta_2-user-role");
      var image = preferences.getString("hejposta_2-user-image");
      var email = preferences.getString("hejposta_2-user-email");
      var username = preferences.getString("hejposta_2-user-username");
      var password = preferences.getString("hejposta_2-user-password");
      var isActive = preferences.  getBool("hejposta_2-user-isActive");
      var createdAt = preferences.getString("hejposta_2-user-createdAt");
      var updatedAt = preferences.getString("hejposta_2-user-updatedAt");

      // Adding postman user
      var postmanId = preferences.getString("hejposta_2-id");
      var fullName = preferences.getString("hejposta_2-fullName");
      var salary = preferences.getInt("hejposta_2-salary");
      var onSuccessDeliveryBonus = preferences.getDouble("hejposta_2-onSuccessDeliveryBonus");
      var note = preferences.getString("hejposta_2-note");
      var phoneNumber = preferences.getString("hejposta_2-phoneNumber");
      var clients = preferences.getStringList("hejposta_2-clients");
      var cities = preferences.getStringList("hejposta_2-cities");
      var units = preferences.getStringList("hejposta_2-units");


      var user = UserModel(
        id: id,
        role: role,
        image: image,
        email: email,
        username: username,
        password: password,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      var postman = PostmanModel(
          postmanId: postmanId,
        user: user,
        units: units,
        fullName: fullName,clients: clients,cities: cities,
        salary: salary,
        onSuccessDeliveryBonus: onSuccessDeliveryBonus,
        note: note,
        phoneNumber: phoneNumber,
      );
      userProvider.addUser(role!, postman, context);
    }
    else{

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Authentication()));
    }
  }

  removeUser(context) async {
    TokenController tokenController  = TokenController();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.removeUser();

    AndroidOptions getAndroidOptions() => const AndroidOptions( encryptedSharedPreferences: true);
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(),);
    await storage.delete(key: "hejposta_2-token");

    SharedPreferences preferences = await SharedPreferences.getInstance();
    var role = preferences.getString("hejposta_2-user-role");
    preferences.setBool("hejposta_2-user", false);

    if(role == "Client"){
      preferences.setBool("hejposta_2-client-user" , false);
      preferences.remove("hejposta_2-user-id");
      preferences.remove("hejposta_2-user-role");
      preferences.remove("hejposta_2-user-image");
      preferences.remove("hejposta_2-user-email");
      preferences.remove("hejposta_2-user-username");
      preferences.remove("hejposta_2-user-password");
      preferences.remove("hejposta_2-user-isActive");
      preferences.remove("hejposta_2-user-createdAt");
      preferences.remove("hejposta_2-user-updatedAt");

      preferences.remove("hejposta_2-client-id");
      preferences.remove("hejposta_2-client-state");
      preferences.remove("hejposta_2-client-cityId");
      preferences.remove("hejposta_2-client-cityName");
      preferences.remove("hejposta_2-client-businessName");
      preferences.remove("hejposta_2-client-address");
      preferences.remove("hejposta_2-client-billAddress");
      preferences.remove("hejposta_2-client-phoneNumber");
      preferences.remove("hejposta_2-client-comment");
      preferences.remove("hejposta_2-client-status");
      preferences.remove("hejposta_2-client-hasPosted");
    }
    else if(role == "Postman"){
      preferences.  setBool("hejposta_2-postman-user" , true);
      preferences.remove("hejposta_2-user-id");
      preferences.remove("hejposta_2-user-role");
      preferences.remove("hejposta_2-user-image");
      preferences.remove("hejposta_2-user-email");
      preferences.remove("hejposta_2-user-username");
      preferences.remove("hejposta_2-user-password");
      preferences.remove("hejposta_2-user-isActive");
      preferences.remove("hejposta_2-user-createdAt");
      preferences.remove("hejposta_2-user-updatedAt");

      preferences.remove("hejposta_2-id");
      preferences.remove("hejposta_2-fullName");
      preferences.remove("hejposta_2-salary");
      preferences.remove("hejposta_2-onSuccessDeliveryBonus");
      preferences.remove("hejposta_2-note");
      preferences.remove("hejposta_2-phoneNumber");
    }
    tokenController.removeToken();
    removeToken();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Authentication()));
  }

  setToken(token) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("hejposta_2-fcm-token",token);
  }

  removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("hejposta_2-fcm-token");
  }

}