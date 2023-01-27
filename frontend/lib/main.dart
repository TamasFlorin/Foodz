import 'package:flutter/material.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/theme.dart';
import 'package:foodz/views/home/home.screen.dart';
import 'package:foodz/views/intro/splash.screen.dart';
import 'package:foodz/views/intro/welcome.screen.dart';

void main() {
  runApp(FoodzApp());
}

class FoodzApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Foodz',
        theme: appTheme,
        home: FutureBuilder(
            future: UserSessionService.fromShared(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen();
              } else {
                return RootView(
                    isUserLoggedIn: UserSessionService().isLoggedIn());
              }
            }));
  }
}

class RootView extends StatefulWidget {
  final bool isUserLoggedIn;
  RootView({Key key, this.isUserLoggedIn}) : super(key: key);

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: !widget.isUserLoggedIn ? WelcomeScreen() : HomeScreen());
  }
}
