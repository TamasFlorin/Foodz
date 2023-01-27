import 'package:foodz/endpoints/base/json.serializable.dart';

class RefreshTokenDto implements JsonSerializable {
  final String token;

  RefreshTokenDto({this.token});

  @override
  Map<String, dynamic> toJson() {
    return {"token": token};
  }
}
