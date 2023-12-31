
import 'package:hejposta/models/user_model.dart';

class PostmanModel {
  dynamic postmanId;
  String? fullName;
  UserModel? user;
  List<dynamic>? clients;
  List<dynamic>? cities;
  List<dynamic>? units;
  int? salary;
  dynamic? onSuccessDeliveryBonus;
  String? note;
  String? phoneNumber;
  dynamic areas = [];
  String? createdAt;
  String? updatedAt;

  PostmanModel({
    this.postmanId,
    this.fullName,
    this.user,
    this.clients,
    this.cities,
    this.units,
    this.salary,
    this.onSuccessDeliveryBonus,
    this.note,
    this.phoneNumber,
    this.areas,
    this.createdAt,
    this.updatedAt,
  });

  factory PostmanModel.fromJson(Map<String, dynamic> fromJson) {
    var postman = fromJson['user']['postman'];

    List<Areas> areas = [];
    for(int i=0;i<postman['areas'].length;i++){
      var a = Areas(name: postman['areas'][i]['name'],cityName: postman['areas'][i]['cityName']);
      areas.add(a);
    }
      print(postman['onSuccessDeliveryBonus']);
    return PostmanModel(
      postmanId: postman['_id'],
      fullName: postman['fullName'],
      user: UserModel.fromJson(fromJson['user']),
      clients: postman['clients'],
      cities: postman['cities'],
      units: postman['units'],
      salary: postman['salary'],
      onSuccessDeliveryBonus: postman['onSuccessDeliveryBonus'],
      note: postman['note'],
      phoneNumber: postman['phoneNumber'],
      areas: areas,
      createdAt: postman['createdAt'],
      updatedAt: postman['updatedAt'],
    );
  }
}

class Areas{
  String? id;
  String? name;
  String? cityName;

  Areas({this.id,this.name,this.cityName});

  factory Areas.fromJson(Map<String, dynamic> json){
    return Areas(
      id: json['_id'],
      name: json['name'],
      cityName: json['cityName'],
    );
  }

  String toStringModel() {

    return "${id!}- ${name!} - ${cityName!}";
  }
}
