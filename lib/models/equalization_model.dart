class EqualizationModel {
  dynamic id;
  String? equalCode;
  dynamic postman;
  bool? status;
  dynamic total;
  dynamic costs;
  dynamic equal;
  dynamic count;
  dynamic debt;
  dynamic clientsPart;
  dynamic postPart;
  dynamic postmanBonuses;
  String? comment;
  dynamic balancedBy;
  bool? equalFinance;
  bool? equalPostman;
  String? createdAt;
  String? updatedAt;

  EqualizationModel({
    this.id,
    this.equalCode,
    this.postman,
    this.status,
    this.total,
    this.costs,
    this.equal,
    this.count,
    this.debt,
    this.clientsPart,
    this.postPart,
    this.postmanBonuses,
    this.comment,
    this.balancedBy,
    this.equalFinance,
    this.equalPostman,
    this.createdAt,
    this.updatedAt,
  });

  factory EqualizationModel.fromJson(Map<String, dynamic> fromJson) {
    return EqualizationModel(
        id: fromJson['_id'],
        equalCode: fromJson['equalCode'],
        postman: fromJson['postman'],
        status: fromJson['status'] == "true"? true:false,
        total: fromJson['total'],
        costs: fromJson['costs'],
        equal: fromJson['equal'],
        count: fromJson['count'],
        debt: fromJson['debt'],
        clientsPart: fromJson['clientsPart'],
        postPart: fromJson['postPart'],
        postmanBonuses: fromJson['postmanBonuses'],
        comment: fromJson['comment'],
        balancedBy: fromJson['balancedBy'],
        equalFinance: fromJson['equalFinance'],
        equalPostman: fromJson['equalPostman'],
        createdAt: fromJson['createdAt'],
        updatedAt: fromJson['updatedAt'],
    );
  }
}
