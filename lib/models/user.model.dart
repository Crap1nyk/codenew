import 'dart:convert';

class User {
  final String name;
  final String email;
  final String phone;
  final String country;
  final String image;

  const User(
    this.name,
    this.email,
    this.phone,
    this.country,
    this.image,
  );

  User fromRawJson(String json) {
    return User.fromJson(jsonDecode(json));
  }

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      data["name"],
      data["email"],
      data["phone"],
      data["country"],
      data["image"],
    );
  }
}
