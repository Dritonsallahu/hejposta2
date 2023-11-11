class CityModel {
  dynamic id;
  String? name;
  String? state;
  String? createdAt;
  String? updatedAt;

  CityModel({
    this.id,
    this.name,
    this.state,
    this.createdAt,
    this.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> fromJson) {
    return CityModel(
      id: fromJson['_id'],
      name: fromJson['name'],
      state: fromJson['state'],
      createdAt: fromJson['createdAt'],
      updatedAt: fromJson['updatedAt'],
    );
  }
}
