import 'package:hejposta/models/client_model.dart';

class OfferModel {
  dynamic id;
  String? offerName;
  dynamic price;
  String? status;
  String? state;
  ClientModel? client;
  String? createdAt;
  String? updatedAt;

  OfferModel({
    this.id,
    this.offerName,
    this.price,
    this.status,
    this.state,
    this.client,
    this.createdAt,
    this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> fromJson) {
    return OfferModel(
      id: fromJson['_id'],
      offerName: fromJson['offertName'],
      price: fromJson['price'],
      status: fromJson['status'],
      state: fromJson['state'],
      client: fromJson['client'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
}
