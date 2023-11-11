class PostmanSalaryModel {
  dynamic id;
  dynamic postman;
  double? payment;
  double? minus;
  int? minusPayed;
  String? note;
  String? month;
  bool? isRegisteredAsOutcome;
  dynamic actionDoneBy;
  String? createdAt;
  String? updatedAt;

  PostmanSalaryModel({
    this.id,
    this.postman,
    this.payment,
    this.minus,
    this.minusPayed,
    this.note,
    this.month,
    this.isRegisteredAsOutcome,
    this.actionDoneBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PostmanSalaryModel.fromJson(Map<String, dynamic> fromJson) {
    return PostmanSalaryModel(
      id: fromJson['_id'],
      postman: fromJson['postman'],
      payment: fromJson['payment'],
      minus: fromJson['minus'],
      minusPayed: fromJson['minus_payed'],
      note: fromJson['note'],
      month: fromJson['month'],
      isRegisteredAsOutcome: fromJson['isRegisteredAsOutcome'],
      actionDoneBy: fromJson['actionDoneBy'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
}
