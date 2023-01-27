import 'package:flutter/foundation.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/models/status.model.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final Status status;

  User(this.id, this.firstName, this.lastName, this.email, this.role,
      this.status);

  static User fromJson(Map<String, dynamic> json) {
    return User(
        json["_id"],
        json["firstName"],
        json["lastName"],
        json["email"],
        json["role"].toString().toUserRole(),
        json["status"].toString().toEntityStatus());
  }
}

class Users {
  final List<User> users;
  Users({@required this.users});

  static Users fromJson(Map<String, dynamic> json) {
    return Users(
        users: json['users'].map<User>((data) => User.fromJson(data)).toList());
  }
}
