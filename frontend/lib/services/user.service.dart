import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:foodz/api/api.client.dart';
import 'package:foodz/endpoints/user.endpoint.dart';
import 'package:foodz/models/dtos/pagination.options.dto.dart';
import 'package:foodz/models/dtos/user.dto.dart';
import 'package:foodz/models/status.model.dart';
import 'package:foodz/models/user.model.dart';
import 'package:foodz/services/exceptions/user.service.exception.dart';

class UserService {
  static final UserService _userService = UserService._internal();

  factory UserService() {
    return _userService;
  }

  UserService._internal();

  Future<User> getInfo(String userId) async {
    final userInfoDto = GetUserInfoDto(userId: userId);
    final responseBody = await ApiClient().request<User>(
        UserEndpoint.getInfo(userInfoDto: userInfoDto).config, User.fromJson);
    if (responseBody.isError) {
      throw UserServiceException(responseBody);
    }
    final User user = responseBody.data;
    return user;
  }

  Future<List<User>> getAll({int pageNumber, int itemsPerPage}) async {
    final getUsersDto = GetUsersDto(
        paginationOptions: PaginationOptions(
            pageNumber: pageNumber, itemsPerPage: itemsPerPage));
    final responseBody = await ApiClient().request<Users>(
        UserEndpoint.getAll(getUsersDto: getUsersDto).config, Users.fromJson);
    if (responseBody.isError) {
      throw UserServiceException(responseBody);
    }
    return responseBody.data.users;
  }

  Future<User> update(
      {@required String userId,
      String firstName,
      String lastName,
      Status status}) async {
    final updateUserDto = UpdateUserDto(
        id: userId, firstName: firstName, lastName: lastName, status: status);
    final responseBody = await ApiClient().request<User>(
        UserEndpoint.update(updateUserDto: updateUserDto).config,
        User.fromJson);
    if (responseBody.isError) {
      throw UserServiceException(responseBody);
    }
    return responseBody.data;
  }

  Future<User> delete({@required String userId}) async {
    final deleteUserDto = DeleteUserDto(id: userId);
    final responseBody = await ApiClient().request<User>(
        UserEndpoint.delete(deleteUserDto: deleteUserDto).config,
        User.fromJson);
    if (responseBody.isError) {
      throw UserServiceException(responseBody);
    }
    return responseBody.data;
  }
}
