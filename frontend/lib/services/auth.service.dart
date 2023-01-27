import 'dart:async';

import 'package:foodz/api/api.client.dart';
import 'package:foodz/endpoints/user.endpoint.dart';
import 'package:foodz/models/dtos/auth.login.dto.dart';
import 'package:foodz/models/dtos/auth.register.dto.dart';
import 'package:foodz/models/dtos/refresh.token.dto.dart';
import 'package:foodz/models/token.model.dart';
import 'package:foodz/models/user.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/exceptions/auth.service.exception.dart';

class AuthService {
  static final AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  Future<TokenData> login(String email, String password) async {
    final loginDto = LoginDto(email, password);
    final responseBody = await ApiClient().request<TokenData>(
        UserEndpoint.login(loginDto: loginDto).config, TokenData.fromJson,
        includeAccessToken: false);
    if (responseBody.isError) {
      throw AuthServiceException(responseBody);
    }
    final TokenData tokenData = responseBody.data;
    return tokenData;
  }

  Future<User> register(String firstName, String lastName, String email,
      String password, UserRole role) async {
    final registerDto =
        RegisterDto(firstName, lastName, email, password, role.string);
    final responseBody = await ApiClient().request<User>(
        UserEndpoint.register(registerDto: registerDto).config, User.fromJson,
        includeAccessToken: false);
    if (responseBody.isError) {
      throw AuthServiceException(responseBody);
    }
    final User user = responseBody.data;
    return user;
  }

  Future<TokenData> refreshToken(String refreshToken) async {
    final refreshTokenDto = RefreshTokenDto(token: refreshToken);
    final responseBody = await ApiClient().request<TokenData>(
        UserEndpoint.refreshToken(refreshTokenDto: refreshTokenDto).config,
        TokenData.fromJson,
        includeAccessToken: false);
    if (responseBody.isError) {
      throw AuthServiceException(responseBody);
    }
    final TokenData tokenData = responseBody.data;
    return tokenData;
  }
}
