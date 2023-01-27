import 'package:foodz/endpoints/base/json.serializable.dart';

class RegisterDto implements JsonSerializable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;

  RegisterDto(
      this.firstName, this.lastName, this.email, this.password, this.role);

  @override
  Map<String, dynamic> toJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
      "password": this.password,
      "role": this.role
    };
  }
}
