class OrderRequestModel {
  dynamic id;
  String? fullName;
  String? email;
  String? address;
  String? city;
  String? state;
  String? phoneNumber;
  String? comment;
  dynamic product;
  dynamic number;
  dynamic qty;
  dynamic client;
  String? productName;
  dynamic? price;
  bool? open;
  bool? brake;
  bool? change;
  String? createdAt;
  String? updatedAt;

  OrderRequestModel({
    this.id,
    this.fullName,
    this.email,
    this.address,
    this.city,
    this.state,
    this.phoneNumber,
    this.comment,
    this.product,
    this.number,
    this.qty,
    this.client,
    this.productName,
    this.price,
    this.open,
    this.brake,
    this.change,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> fromJson) {
    return OrderRequestModel(
        id: fromJson['_id'],
        fullName: fromJson['fullName'],
        email: fromJson['email'],
        address: fromJson['address'],
        city: fromJson['city'],
        state: fromJson['state'],
        phoneNumber: fromJson['phoneNumber'],
        comment: fromJson['comment'],
        product: fromJson['product'],
        number: fromJson['number'],
        qty: fromJson['qty'],
        client: fromJson['client'],
        productName: fromJson['productName'],
        price: fromJson['price'],
        open: fromJson['open'],
        brake: fromJson['brake'],
        change: fromJson['change'],
        createdAt: fromJson['createdAt'],
        updatedAt: fromJson['updatedAt'],
    );
  }
}
