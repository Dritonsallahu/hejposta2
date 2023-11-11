class ReceiverModel {
  String? fullName;
  String? address;
  String? city;
  String? state;
  String? phoneNumber;

  ReceiverModel({
    this.fullName,
    this.address,
    this.city,
    this.state,
    this.phoneNumber,
  });

  factory ReceiverModel.fromJson(Map<String, dynamic> fromJson){
    return ReceiverModel(
        fullName: fromJson['fullName'],
        address: fromJson['address'],
        city: fromJson['city'],
        state: fromJson['state'],
        phoneNumber: fromJson['phoneNumber'],
    );
  }
}
