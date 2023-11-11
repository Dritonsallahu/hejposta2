class GoalModel {
  dynamic id;
  dynamic client;
  dynamic startDate;
  dynamic endDate;
  int? orderNumber;
  int? numberCompleted;
  String? createdAt;
  String? updatedAt;

  GoalModel({
    this.id,
    this.client,
    this.startDate,
    this.endDate,
    this.orderNumber,
    this.numberCompleted,
    this.createdAt,
    this.updatedAt,
  });

  factory GoalModel.fromJson(Map<String, dynamic> fromJson) {
    return GoalModel(
        id: fromJson['id'],
        client: fromJson['client'],
        startDate: fromJson['startDate'],
        endDate: fromJson['endDate'],
        orderNumber: fromJson['orderNumber'],
        numberCompleted: fromJson['numberCompleted'],
        createdAt: fromJson['createdAt'],
        updatedAt: fromJson['updatedAt'],
    );
  }
}
