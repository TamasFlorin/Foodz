import 'package:foodz/api/api.client.dart';
import 'package:foodz/services/exceptions/base.exception.dart';

class ReviewServiceException extends BaseException {
  ReviewServiceException([ApiResponse response])
      : super(errorCode: response.statusCode);
}
