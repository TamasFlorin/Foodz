import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodz/models/token.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/auth.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionData {
  String userId;
  String token;
  String refreshToken;
  UserRole role;
  DateTime expiration;

  UserSessionData(
      {@required this.userId,
      @required this.token,
      @required this.refreshToken,
      @required this.role,
      @required this.expiration});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "token": token,
      "refreshToken": refreshToken,
      "role": role.string,
      "expiration": expiration.toIso8601String()
    };
  }

  UserSessionData.fromJson(Map<String, dynamic> json)
      : userId = json["userId"],
        token = json["token"],
        refreshToken = json["refreshToken"],
        role = json["role"].toString().toUserRole(),
        expiration = DateTime.parse(json["expiration"]);

  UserSessionData.fromTokenData({@required TokenData tokenData})
      : userId = tokenData.userId,
        token = tokenData.token,
        refreshToken = tokenData.refreshToken,
        role = tokenData.role,
        expiration = DateTime.now().add(Duration(seconds: tokenData.expiresIn));
}

class UserSessionService {
  UserSessionData _sessionData;
  static final UserSessionService _userSession = UserSessionService._internal();
  static const String SESSION_REF = "session";

  factory UserSessionService() {
    return _userSession;
  }

  String get userId => _sessionData?.userId;
  UserRole get role => _sessionData?.role;

  Future<String> get token async {
    if (_sessionData == null) {
      return null;
    }
    await this._refreshToken();
    return _sessionData.token;
  }

  static Future<UserSessionService> fromShared() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String sessionInfo = sharedPreferences.getString(SESSION_REF);
    if (sessionInfo != null) {
      final sessionInfoJson = jsonDecode(sessionInfo);
      final sessionData = UserSessionData.fromJson(sessionInfoJson);
      _userSession._sessionData = sessionData;
    }

    return _userSession;
  }

  Future<void> login({@required TokenData tokenData}) async {
    _sessionData = UserSessionData.fromTokenData(tokenData: tokenData);
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(SESSION_REF, jsonEncode(_sessionData.toJson()));
  }

  Future<void> logout() async {
    _sessionData = null;
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.remove(SESSION_REF);
  }

  bool isLoggedIn() {
    return _sessionData != null;
  }

  Future<void> _refreshToken() async {
    if (DateTime.now().isAfter(_sessionData.expiration)) {
      final tokenData =
          await AuthService().refreshToken(_sessionData.refreshToken);
      await login(tokenData: tokenData);
    }
  }

  UserSessionService._internal();
}
