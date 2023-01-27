import 'package:foodz/api/api.client.dart';
import 'package:foodz/services/exceptions/base.exception.dart';

class RestaurantServiceException extends BaseException {
  RestaurantServiceException([ApiResponse response])
      : super(errorCode: response.statusCode);
}
