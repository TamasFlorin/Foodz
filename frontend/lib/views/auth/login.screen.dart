import 'package:flutter/material.dart';
import 'package:foodz/services/auth.service.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/util/util.dart';
import 'package:foodz/views/auth/register.screen.dart';
import 'package:foodz/views/home/home.screen.dart';

import '../../constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              width: 0.8 * constraints.maxWidth,
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            APP_LOGO,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(height: 50),
                        TextFormField(
                            decoration: InputDecoration(hintText: 'Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field cannot be empty.';
                              } else if (!isValidEmail(value)) {
                                return "Invalid email address.";
                              }
                              return null;
                            },
                            controller: emailTextController,
                            keyboardType: TextInputType.emailAddress),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field cannot be empty.";
                            }
                            return null;
                          },
                          controller: passwordTextController,
                          obscureText: true,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 0.01 * constraints.maxHeight)),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                child: Text("Login"),
                                onPressed: _handleLoginAction)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account yet?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child: Text("Sign up"))
                            ])
                      ]))),
        ),
      ),
    );
  }

  Future<void> _handleLoginAction() async {
    try {
      if (_formKey.currentState != null && _formKey.currentState.validate()) {
        final user = await AuthService().login(
            this.emailTextController.text, this.passwordTextController.text);
        final _ = await UserSessionService().login(tokenData: user);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      }
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }
}
