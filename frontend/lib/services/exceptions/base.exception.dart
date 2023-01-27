import 'package:flutter/foundation.dart';
import 'package:foodz/services/exceptions/error.handler.dart';

class BaseException implements Exception {
  final String _message;
  BaseException({@required int errorCode})
      : _message = parseErrorResponse(errorCode: errorCode);

  @override
  String toString() {
    return this._message;
  }
}
