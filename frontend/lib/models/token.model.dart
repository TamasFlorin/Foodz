import 'package:foodz/models/user.role.model.dart';

class TokenData {
  final String token;
  final String refreshToken;
  final int expiresIn; // ms
  final String userId;
  final UserRole role;

  TokenData(
      this.token, this.refreshToken, this.expiresIn, this.userId, this.role);

  static TokenData fromJson(Map<String, dynamic> json) {
    return TokenData(json["token"], json["refreshToken"], json["expiresIn"],
        json["userId"], json["role"].toString().toUserRole());
  }
}
