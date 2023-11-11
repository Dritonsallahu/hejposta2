class UserModel {
  dynamic id;
  String? role;
  String? image;
  String? email;
  String? username;
  String? password;
  bool? isActive;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    this.role,
    this.image,
    this.email,
    this.username,
    this.password,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> fromJson) {
    return UserModel(
      id: fromJson['_id'],
      role: fromJson['role'],
      image: fromJson['image'],
      email: fromJson['email'],
      username: fromJson['username'],
      password: fromJson['password'],
      isActive: fromJson['isActive'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
}
