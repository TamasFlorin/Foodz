import 'package:foodz/util/util.dart';

enum Status { ACTIVE, DISABLED }

extension UserStatusExtension on Status {
  String get string => enumToString(this);
}

extension StringExtensionForRole on String {
  Status toEntityStatus() {
    if (this == Status.ACTIVE.string) {
      return Status.ACTIVE;
    } else if (this == Status.DISABLED.string) {
      return Status.DISABLED;
    }
    return null;
  }
}
