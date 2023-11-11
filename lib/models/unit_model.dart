class UnitModel {
  dynamic id;
  dynamic client;
  String? unitName;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;

  UnitModel({
    this.id,
    this.client,
    this.unitName,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UnitModel.fromJson(Map<String, dynamic> fromJson) {

    return UnitModel(
      id: fromJson['_id'],
      client: fromJson['client'],
      unitName: fromJson['unitName'],
      address: fromJson['address'],
      status: fromJson['status'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
}
