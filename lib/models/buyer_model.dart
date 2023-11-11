class BuyerModel {
  dynamic id;
  String? client;
  String? fullName;
  String? address;
  String? city;
  String? state;
  String? phoneNumber;
  bool checked = false;
  String? createdAt;
  String? updatedAt;

  BuyerModel({
    this.id,
    this.client,
    this.fullName,
    this.address,
    this.city,
    this.state,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory BuyerModel.fromJson(Map<String, dynamic> fromJson) {
    return BuyerModel(
        id: fromJson['_id'],
        client: fromJson['client'],
        fullName: fromJson['fullName'],
        address: fromJson['address'],
        city: fromJson['city'],
        state: fromJson['state'],
        phoneNumber: fromJson['phoneNumber'],
        createdAt: fromJson['createdAt'],
        updatedAt: fromJson['updatedAt'],
    );
  }
}
