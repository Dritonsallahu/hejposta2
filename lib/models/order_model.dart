import 'package:hejposta/models/offer_model.dart';
import 'package:hejposta/models/receiver_model.dart';
import 'package:hejposta/models/sender_model.dart';

class OrderModel {
  dynamic id;
  String? orderName;
  String? orderNumber;
  SenderModel? sender;
  ReceiverModel? receiver;
  dynamic offer;
  dynamic price;
  String? status;
  String? returnedReason;
  String? returningStatus;
  String? rejectedReason;
  dynamic deliveringPostman;
  bool? deleted;
  bool? barazimiAdministrat;
  bool? barazimiKlient;
  String? equalCode;
  String? equalCodeWithClient;
  bool? open;
  bool? brake;
  bool? change;
  int? qty;
  String? comment;
  dynamic unit;
  dynamic product;
  bool? isEqualedWithThanaDev;
  String? deliveringToThanaStatus;
  String? createdAt;
  String? updatedAt;
  String? zone;
  bool loading = false;

  OrderModel({
    this.id,
    this.orderName,
    this.orderNumber,
    this.sender,
    this.receiver,
    this.offer,
    this.price,
    this.status,
    this.returnedReason,
    this.returningStatus,
    this.rejectedReason,
    this.deliveringPostman,
    this.deleted,
    this.barazimiAdministrat,
    this.barazimiKlient,
    this.equalCode,
    this.equalCodeWithClient,
    this.open,
    this.brake,
    this.change,
    this.qty,
    this.comment,
    this.unit,
    this.product,
    this.isEqualedWithThanaDev,
    this.deliveringToThanaStatus,
    this.createdAt,
    this.updatedAt,
    this.zone,
  });

  factory OrderModel.fromJson(Map<String, dynamic> fromJson) {

    return OrderModel(
      id: fromJson['_id'],
      orderName: fromJson['orderName'],
      orderNumber: fromJson['order_number'],
      sender: SenderModel.fromJson(fromJson['sender']),
      receiver: ReceiverModel.fromJson(fromJson['receiver']),
      offer: fromJson['offer'].toString().contains("offerId") ? fromJson['offer']: OfferModel.fromJson(fromJson['offer']),
      price: fromJson['price'],
      status: fromJson['status'],
      returnedReason: fromJson['returned_reason'],
      returningStatus: fromJson['returning_status'],
      rejectedReason: fromJson['rejected_reason'],
      deliveringPostman: fromJson['deliveringPostman'],
      deleted: fromJson['deleted'],
      barazimiAdministrat: fromJson['barazimiAdministrat'],
      barazimiKlient: fromJson['barazimiKlient'],
      equalCode: fromJson['equalCode'],
      equalCodeWithClient: fromJson['equalCodeWithClient'],
      open: fromJson['open'],
      brake: fromJson['brake'],
      change: fromJson['change'],
      qty: fromJson['qty'],
      comment: fromJson['comment'],
      unit: fromJson['unit'],
      product: fromJson['product'],
      isEqualedWithThanaDev: fromJson['isEqualedWithThanaDev'],
      deliveringToThanaStatus: fromJson['deliveringToThanaStatus'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
      zone: fromJson['zone'],
    );
  }
}
