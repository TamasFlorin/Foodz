import 'package:flutter/material.dart';
import 'package:foodz/api/api.client.dart';
import 'package:foodz/constants.dart';
import 'package:foodz/endpoints/base/json.serializable.dart';
import 'package:foodz/models/dtos/auth.login.dto.dart';
import 'package:foodz/models/dtos/auth.register.dto.dart';
import 'package:foodz/models/dtos/refresh.token.dto.dart';
import 'package:foodz/models/dtos/user.dto.dart';

import 'base/base.endpoint.dart';

class UserEndpoint implements Endpoint {
  static const String _baseUrl = '$SERVER_URL/users';
  final RequestConfig _requestConfig;

  UserEndpoint.login({@required LoginDto loginDto})
      : _requestConfig = RequestConfig(
            Uri.parse('$_baseUrl/login'), RequestMethod.POST,
            body: bodyFromJsonSerializable(loginDto));

  UserEndpoint.register({@required RegisterDto registerDto})
      : _requestConfig = RequestConfig(
            Uri.parse('$_baseUrl/register'), RequestMethod.POST,
            body: bodyFromJsonSerializable(registerDto));

  UserEndpoint.refreshToken({@required RefreshTokenDto refreshTokenDto})
      : _requestConfig = RequestConfig(
            Uri.parse('$_baseUrl/refreshToken'), RequestMethod.POST,
            body: bodyFromJsonSerializable(refreshTokenDto));

  UserEndpoint.getInfo({@required GetUserInfoDto userInfoDto})
      : _requestConfig = RequestConfig(
            Uri.parse('$_baseUrl/get/${userInfoDto.userId}'),
            RequestMethod.GET);

  UserEndpoint.getAll({@required GetUsersDto getUsersDto})
      : _requestConfig = RequestConfig(
            Uri.parse('$_baseUrl/get'), RequestMethod.POST,
            body: bodyFromJsonSerializable(getUsersDto));

  UserEndpoint.update({@required UpdateUserDto updateUserDto})
      : _requestConfig = RequestConfig(
            Uri.parse('$_baseUrl/update'), RequestMethod.PUT,
            body: bodyFromJsonSerializable(updateUserDto));

  UserEndpoint.delete({@required DeleteUserDto deleteUserDto})
      : _requestConfig = RequestConfig(
          Uri.parse('$_baseUrl/delete/${deleteUserDto.id}'),
          RequestMethod.DELETE,
        );

  RequestConfig get config => _requestConfig;
}
