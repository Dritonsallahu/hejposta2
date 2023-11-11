class ReceiverModel {
  String? id;
  String? fullName;
  String? address;
  String? city;
  String? state;
  String? phoneNumber;

  ReceiverModel({
    this.id,
    this.fullName,
    this.address,
    this.city,
    this.state,
    this.phoneNumber,
  });

  factory ReceiverModel.fromJson(Map<String, dynamic> fromJson){

    return ReceiverModel(
        id: fromJson['buyer'],
        fullName: fromJson['fullName'],
        address: fromJson['address'],
        city: fromJson['city'],
        state: fromJson['state'],
        phoneNumber: fromJson['phoneNumber'],
    );
  }
}
