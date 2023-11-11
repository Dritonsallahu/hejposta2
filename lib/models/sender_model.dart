class SenderModel {
  dynamic id;
  String? username;
  String? email;
  String? businessName;
  String? state;
  String? city;
  String? address;
  String? phoneNumber;

  SenderModel({
    this.id,
    this.username,
    this.email,
    this.businessName,
    this.state,
    this.city,
    this.address,
    this.phoneNumber,
  });

  factory SenderModel.fromJson(var fromJson){

    return SenderModel(
        id: fromJson['_id'],
        username: fromJson['username'],
        email: fromJson['email'],
        businessName: fromJson['businessName'],
        state: fromJson['state'],
        city: fromJson['city'],
        address: fromJson['address'],
        phoneNumber: fromJson['phoneNumber'],
    );
  }
}
