import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodz/views/auth/login.screen.dart';
import 'package:foodz/views/auth/register.screen.dart';

import '../../constants.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: constraints.maxWidth,
          child: Padding(
            padding: EdgeInsets.only(
                left: 0, right: 0, top: 0.05 * constraints.maxHeight),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Welcome to Foodz!",
                  style: Theme.of(context).textTheme.headline6),
              Padding(
                  padding: EdgeInsets.only(top: 0.02 * constraints.maxHeight)),
              Text("Foodz is your go-to place for restaurant reviews."),
              Padding(
                  padding: EdgeInsets.only(top: 0.05 * constraints.maxHeight)),
              Container(
                  height: 0.4 * constraints.maxHeight,
                  width: 0.9 * constraints.maxWidth,
                  //color: Colors.red,
                  child: SvgPicture.asset(
                    REVIEW_ILLUSTRATION_ASSET,
                    semanticsLabel: 'Review visualization',
                    alignment: Alignment.topCenter,
                  )),
              Container(
                  width: constraints.maxWidth,
                  //color: Colors.red,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: constraints.maxWidth * 0.4,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: Text("Log In"))),
                        Container(
                            width: constraints.maxWidth * 0.4,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()));
                                },
                                child: Text("Register"))),
                      ]))
            ]),
          ),
        ),
        //appBar: AppBar(title: Text("Welcome to Foodz!")),
      ),
    );
  }
}
