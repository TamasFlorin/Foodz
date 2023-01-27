import 'package:foodz/util/util.dart';

enum UserRole { REGULAR, OWNER, ADMIN }

extension UserRoleExtension on UserRole {
  String get string => enumToString(this);
}

extension StringExtensionForRole on String {
  UserRole toUserRole() {
    if (this == UserRole.REGULAR.string) {
      return UserRole.REGULAR;
    } else if (this == UserRole.ADMIN.string) {
      return UserRole.ADMIN;
    } else if (this == UserRole.OWNER.string) {
      return UserRole.OWNER;
    }
    return null;
  }
}
