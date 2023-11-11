class MessageModel {
  dynamic id;
  dynamic by;
  dynamic to;
  String? message;
  String? status;
  String? createdAt;
  String? updatedAt;

  MessageModel({
    this.id,
    this.by,
    this.to,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> fromJson) {
    return MessageModel(
        id: fromJson['id'],
        by: fromJson['by'],
        to: fromJson['to'],
        message: fromJson['message'],
        status: fromJson['status'],
        createdAt: fromJson['createdAt'],
        updatedAt: fromJson['updatedAt'],
    );
  }
}
