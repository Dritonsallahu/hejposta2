class CommentModel {
  dynamic id;
  dynamic order;
  dynamic user;
  dynamic postman;
  dynamic body;
  String? createdAt;
  String? updatedAt;

  CommentModel({
    this.id,
    this.order,
    this.user,
    this.postman,
    this.body,
    this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> fromJson) {
    return CommentModel(
        id: fromJson['id'],
        order: fromJson['order'],
        user: fromJson['user'],
        postman: fromJson['postman'],
        body: fromJson['body'],
        createdAt: fromJson['createdAt'],
        updatedAt: fromJson['updatedAt'],
    );
  }
}
