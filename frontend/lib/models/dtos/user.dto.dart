import 'package:flutter/material.dart';
import 'package:foodz/endpoints/base/json.serializable.dart';
import 'package:foodz/models/dtos/pagination.options.dto.dart';
import 'package:foodz/util/util.dart';

import '../status.model.dart';

class GetUserInfoDto implements JsonSerializable {
  String userId;
  GetUserInfoDto({@required this.userId});

  Map<String, dynamic> toJson() {
    return {"userId": this.userId};
  }
}

class GetUsersDto implements JsonSerializable {
  final PaginationOptions paginationOptions;
  GetUsersDto({this.paginationOptions});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys(
        {"paginationOptions": this.paginationOptions?.toJson()});
  }
}

class UpdateUserDto implements JsonSerializable {
  final String id;
  final String firstName;
  final String lastName;
  final Status status;
  UpdateUserDto(
      {@required this.id, this.firstName, this.lastName, this.status});

  @override
  Map<String, dynamic> toJson() {
    return onlyDefinedKeys({
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'status': status.string,
    });
  }
}

class DeleteUserDto implements JsonSerializable {
  final String id;
  DeleteUserDto({@required this.id});

  @override
  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
