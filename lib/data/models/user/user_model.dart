


import 'package:n8_default_project/data/models/user/adress_model.dart';
import 'package:n8_default_project/data/models/user/name_model.dart';

class UserModel {
  AddressModel address;
  int id;
  String email;
  String username;
  String password;
  NameModel name;
  String phone;
  int v;

  UserModel({
    required this.address,
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        address: AddressModel.fromJson(json["address"]),
        id: json["id"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        name: NameModel.fromJson(json["name"]),
        phone: json["phone"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
