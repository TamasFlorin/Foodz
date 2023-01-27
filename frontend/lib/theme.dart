import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final HexColor primaryColor = HexColor('#FBA474');
final Color accentColor = primaryColor.withOpacity(0.6);
final HexColor lightAccentColor = HexColor('#D9F6FD');
final HexColor canvasBackgroundColor = HexColor('#FBF8F5');

final ThemeData appTheme = ThemeData(
    primaryColor: primaryColor,
    accentColor: accentColor,
    canvasColor: canvasBackgroundColor,
    buttonColor: primaryColor,
    primaryColorDark: primaryColor,
    primaryColorLight: primaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      primary: primaryColor,
    )),
    textButtonTheme:
        TextButtonThemeData(style: TextButton.styleFrom(primary: primaryColor)),
    appBarTheme: AppBarTheme(
        elevation: 0.5,
        backgroundColor: canvasBackgroundColor,
        iconTheme: IconThemeData(color: primaryColor)),
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) => primaryColor)));
