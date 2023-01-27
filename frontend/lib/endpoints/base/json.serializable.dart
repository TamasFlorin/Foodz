import 'dart:convert';
import 'dart:io';

import 'package:foodz/api/api.client.dart';

abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}

RequestBody bodyFromJsonSerializable<T extends JsonSerializable>(T body) {
  if (body == null) return null;
  final json = body.toJson();
  if (json == null) return null;
  final jsonEncoded = jsonEncode(body.toJson());
  if (jsonEncoded == null) return null;
  final requestBody = RequestBody(ContentType.json, jsonEncoded);
  return requestBody;
}
