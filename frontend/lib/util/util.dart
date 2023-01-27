import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool isValidEmail(String email) {
  final emailRegex = RegExp(
      r"^[A-Za-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?$");
  return emailRegex.hasMatch(email);
}

String enumToString(dynamic enumItem) {
  return enumItem.toString().split('.').last;
}

Map<String, dynamic> onlyDefinedKeys(Map<String, dynamic> map) {
  final Map<String, dynamic> filteredMap = Map.from(map)
    ..removeWhere((_, value) => value == null);
  return filteredMap.isEmpty ? null : filteredMap;
}

Future<void> showSuccessMessage({String message}) async {
  Fluttertoast.showToast(msg: message, backgroundColor: Colors.green[300]);
}

Future<void> showErrorMessage({String message}) async {
  Fluttertoast.showToast(msg: message, backgroundColor: Colors.red);
}
