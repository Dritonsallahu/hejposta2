class ProductModel {
  dynamic id;
  dynamic client;
  String? productName;
  String? image;
  dynamic price;
  dynamic qty;
  String? describe;
  dynamic sales;
  bool? open;
  bool? brake;
  bool? change;
  bool checked = false;
  String? createdAt;
  String? updatedAt;

  ProductModel({
    this.id,
    this.client,
    this.productName,
    this.image,
    this.price,
    this.qty,
    this.describe,
    this.sales,
    this.open,
    this.brake,
    this.change,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> fromJson) {
    return ProductModel(
      id: fromJson['_id'],
      client: fromJson['client'],
      productName: fromJson['productName'],
      image: fromJson['image'],
      price: fromJson['price'],
      qty: fromJson['qty'],
      describe: fromJson['describe'],
      sales: fromJson['sales'],
      open: fromJson['open'],
      brake: fromJson['brake'],
      change: fromJson['change'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
  static Map<String, dynamic> toJson(
    id,
    client,
    productName,
    image,
    price,
    qty,
    describe,
    sales,
    open,
    brake,
    change,
    createdAt,
    updatedAt,
  ) =>
      {
        '_id': id,
        'client': client,
        'productName': productName,
        'image': image,
        'price': price,
        'qty': qty,
        'describe': describe,
        'sales': sales,
        'open': open,
        'brake': brake,
        'change': change,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}
