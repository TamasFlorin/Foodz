import 'package:foodz/api/api.client.dart';
import 'package:foodz/services/exceptions/base.exception.dart';

class UserServiceException extends BaseException {
  UserServiceException([ApiResponse response])
      : super(errorCode: response.statusCode);
}
