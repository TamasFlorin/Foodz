import 'package:foodz/api/api.client.dart';
import 'package:foodz/services/exceptions/base.exception.dart';

class AuthServiceException extends BaseException {
  AuthServiceException([ApiResponse response])
      : super(errorCode: response.statusCode);
}
