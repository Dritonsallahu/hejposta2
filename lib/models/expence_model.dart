class ExpenceModel {
  dynamic id;
  String? reason;
  dynamic postman;
  String? document;
  dynamic total;
  bool? status;
  dynamic expenceDate;
  String? createdAt;
  String? updatedAt;

  ExpenceModel({
    this.id,
    this.reason,
    this.postman,
    this.document,
    this.total,
    this.status,
    this.expenceDate,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenceModel.fromJson(Map<String, dynamic> fromJson) {
    return ExpenceModel(
      id: fromJson['_id'],
      reason: fromJson['reason'],
      postman: fromJson['postman'],
      document: fromJson['document'],
      total: fromJson['total'],
      status: fromJson['status'],
      expenceDate: fromJson['expenceDate'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
}
