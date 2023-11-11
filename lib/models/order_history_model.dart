class OrderHistoryModel {
  dynamic id;
  dynamic orderId;
  dynamic updates;
  dynamic updatePrice;
  String? createdAt;
  String? updatedAt;

  OrderHistoryModel({
    this.id,
    this.orderId,
    this.updates,
    this.updatePrice,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> fromJson) {
    return OrderHistoryModel(
        id: fromJson['id'],
        orderId: fromJson['orderId'],
        updates: fromJson['updates'],
        updatePrice: fromJson['updatePrice'],
    );
  }
}
