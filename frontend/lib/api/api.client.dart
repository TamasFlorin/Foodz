import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/util/util.dart';

enum RequestMethod { GET, POST, PUT, DELETE, PATCH }

extension ParseToString on RequestMethod {
  String get string => enumToString(this.toString());
}

class RequestBody {
  final ContentType contentType;
  final String data;
  RequestBody(this.contentType, this.data);

  bool get isEmpty => data == null || data.isEmpty;
}

class ApiResponse<T> {
  final String message;
  final T data;
  final int statusCode;
  final bool isError;

  ApiResponse.success(
      {@required this.data, @required this.message, this.statusCode})
      : isError = false;
  ApiResponse.error({@required this.statusCode, this.message, this.data})
      : isError = true;
}

class RequestConfig {
  final Uri url;
  final RequestMethod method;
  final Map<String, dynamic> headers;
  final RequestBody body;

  RequestConfig(this.url, this.method,
      {this.headers = const <String, dynamic>{}, this.body});

  bool get hasBody => body != null && !body.isEmpty;
  bool get hasHeaders => headers?.isNotEmpty;

  void addHeader(String name, dynamic value) {
    headers[name] = value;
  }
}

typedef JsonConverter<T> = T Function(Map<String, dynamic>);

class ApiClient {
  static final ApiClient _apiClient = ApiClient._internal();
  final HttpClient _client = HttpClient();

  factory ApiClient() {
    return _apiClient;
  }

  ApiClient._internal();

  Future<ApiResponse<T>> request<T>(
      RequestConfig requestConfig, JsonConverter<T> converter,
      {bool includeAccessToken = true}) async {
    try {
      final HttpClientRequest httpRequest =
          await _client.openUrl(requestConfig.method.string, requestConfig.url);

      await _addHeaders(httpRequest, requestConfig, includeAccessToken);
      _addBody(httpRequest, requestConfig);

      final HttpClientResponse httpResponse = await httpRequest.close();
      if (_isSucessfull(httpResponse.statusCode)) {
        final response = await _readResponse(httpResponse);
        return ApiResponse.success(
            data: converter(response['data']),
            message: response['message'],
            statusCode: httpResponse.statusCode);
      }

      return ApiResponse.error(statusCode: httpResponse.statusCode);
    } catch (ex) {
      return ApiResponse.error(statusCode: 500);
    }
  }

  static bool _isSucessfull(int statusCode) {
    switch (statusCode) {
      case HttpStatus.ok:
        return true;
      case HttpStatus.created:
        return true;
      case HttpStatus.accepted:
        return true;
      default:
        return false;
    }
  }

  Future<Map<String, dynamic>> _readResponse(
      HttpClientResponse response) async {
    final contents = StringBuffer();
    await for (var data in response.transform(utf8.decoder)) {
      contents.write(data);
    }
    return json.decode(contents.toString());
  }

  Future<void> _addHeaders(HttpClientRequest request,
      RequestConfig requestConfig, bool includeAccessToken) async {
    requestConfig.headers
        .forEach((key, value) => request.headers.add(key, value));

    if (includeAccessToken) {
      final userToken = await UserSessionService().token;
      if (userToken != null) {
        request.headers.add("Authorization", 'Bearer $userToken');
      }
    }
  }

  void _addBody(HttpClientRequest request, RequestConfig requestConfig) {
    if (requestConfig.hasBody) {
      request.headers.contentType = requestConfig.body.contentType;
      request.contentLength =
          const Utf8Encoder().convert(requestConfig.body.data).length;
      request.write(requestConfig.body.data);
    }
  }
}
