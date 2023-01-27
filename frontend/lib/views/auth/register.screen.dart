import 'package:flutter/material.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/auth.service.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/util/util.dart';
import 'package:foodz/views/home/home.screen.dart';
import 'package:foodz/views/restaurant/restaurant.claim.screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isBusinessOwner = false;
  final _formKey = GlobalKey<FormState>();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints boxConstraints) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              child: Center(
                child: Container(
                  width: 0.8 * boxConstraints.maxWidth,
                  //color: Colors.red,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Register",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headline6),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 0.02 * boxConstraints.maxHeight)),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'First Name'),
                          controller: _firstNameTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field cannot be empty.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Last Name'),
                          controller: _lastNameTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field cannot be empty.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(hintText: 'Email Address'),
                          controller: _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field cannot be empty.';
                            } else if (!isValidEmail(value)) {
                              return "Invalid email address.";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(hintText: 'Password'),
                          obscureText: true,
                          controller: _passwordTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field cannot be empty.';
                            }
                            return null;
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: 0.01 * boxConstraints.maxHeight)),
                        CheckboxListTile(
                            title: Text("I want to claim my own business"),
                            value: _isBusinessOwner,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              setState(() {
                                _isBusinessOwner = value;
                              });
                            }),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              child: Text("Register"),
                              onPressed: _handleRegisterAction),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              padding: EdgeInsets.only(
                  left: 0.06 * boxConstraints.maxWidth,
                  right: 0.06 * boxConstraints.maxWidth,
                  top: 0.05 * boxConstraints.maxHeight)),
        ));
  }

  Future<void> _handleRegisterAction() async {
    try {
      if (_formKey.currentState != null && _formKey.currentState.validate()) {
        await AuthService().register(
            _firstNameTextController.text,
            _lastNameTextController.text,
            _emailTextController.text,
            _passwordTextController.text,
            _isBusinessOwner ? UserRole.OWNER : UserRole.REGULAR);

        // we automatically login the user after registration
        final tokenData = await AuthService()
            .login(_emailTextController.text, _passwordTextController.text);
        await UserSessionService().login(tokenData: tokenData);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          if (_isBusinessOwner) {
            return RestaurantClaimScreen();
          } else {
            return HomeScreen();
          }
        }), (_) => false);
      }
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }
}
