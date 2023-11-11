import 'package:hejposta/models/offer_model.dart';
import 'package:hejposta/models/user_model.dart';

class ClientModel {
  dynamic clientId;
  UserModel? user;
  String? businessName;
  String? state;
  dynamic city;
  String? address;
  String? billAddress;
  String? phoneNumber;
  List<OfferModel>? offert;
  String? comment;
  String? status;
  bool? hasPosted;
  String? createdAt;
  String? updatedAt;

  ClientModel({
    this.clientId,
    this.user,
    this.businessName,
    this.state,
    this.city,
    this.address,
    this.billAddress,
    this.phoneNumber,
    this.offert,
    this.comment,
    this.status,
    this.hasPosted,
    this.createdAt,
    this.updatedAt,
  });

  factory ClientModel.fromJson(Map<String, dynamic> fromJson) {
    var cl = fromJson['user']['client'];
    var offert = fromJson['user']['offert'];
    var user = fromJson['user'];
    return ClientModel(
      clientId: cl['_id'],
      user: UserModel.fromJson(user),
      businessName: cl['businessName'],
      state: cl['state'],
      city: cl['city'],
      address: cl['address'],
      billAddress: cl['billAddress'],
      phoneNumber: cl['phoneNumber'],
      offert: offert,
      comment: cl['comment'],
      status: cl['status'],
      hasPosted: cl['hasPosted'],
      createdAt: cl['createdAt'],
      updatedAt: cl['updatedAt'],
    );
  }
}
