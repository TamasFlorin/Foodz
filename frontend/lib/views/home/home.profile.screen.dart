import 'package:flutter/material.dart';
import 'package:foodz/models/user.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/models/status.model.dart';
import 'package:foodz/services/user.service.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/util/util.dart';
import 'package:foodz/views/intro/welcome.screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final bool isInEditingMode;

  ProfileScreen({@required this.userId, this.isInEditingMode = false});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userStatus;
  String _userRole;
  final _firstNameController = TextEditingController();
  final _lastNameEditingController = TextEditingController();
  final _emailEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  User _user;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
            appBar: widget.isInEditingMode ? AppBar() : null,
            body: _build(context, constraints)));
  }

  Future<void> _getUserInfo() async {
    try {
      final userInfo = await UserService().getInfo(widget.userId);
      setState(() {
        _user = userInfo;
        _userStatus = _user.status.string;
        _userRole = _user.role.string;
        _firstNameController.text = _user.firstName;
        _lastNameEditingController.text = _user.lastName;
        _emailEditingController.text = _user.email;
      });
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: FutureBuilder(
          key: UniqueKey(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      backgroundColor: Theme.of(context).primaryColor));
            }
            return _buildUserInfo(context, constraints);
          },
          future: UserService().getInfo(widget.userId)),
    );
  }

  Widget _buildUserInfo(BuildContext context, BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: Scaffold(
          body: SafeArea(
        child: Padding(
            padding: EdgeInsets.only(
                top: 0.06 * constraints.maxHeight,
                left: 0.06 * constraints.maxWidth,
                right: 0.06 * constraints.maxWidth),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_box_rounded,
                      size: 100, color: Theme.of(context).primaryColor),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'First Name',
                    ),
                    readOnly: UserSessionService().role != UserRole.ADMIN,
                    controller: _firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                    readOnly: UserSessionService().role != UserRole.ADMIN,
                    controller: _lastNameEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field cannot be empty';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Email',
                    ),
                    readOnly: true,
                    initialValue: _user?.email,
                  ),
                  DropdownButtonFormField(
                      value: _userRole,
                      items: [
                        DropdownMenuItem(child: Text('Admin'), value: 'ADMIN'),
                        DropdownMenuItem(child: Text('Owner'), value: 'OWNER'),
                        DropdownMenuItem(
                            child: Text('Regular'), value: 'REGULAR')
                      ],
                      onChanged: null),
                  DropdownButtonFormField(
                      value: _userStatus,
                      items: [
                        DropdownMenuItem(
                            child: Text('Active'), value: 'ACTIVE'),
                        DropdownMenuItem(
                            child: Text('Disabled'), value: 'DISABLED')
                      ],
                      onChanged: !widget.isInEditingMode
                          ? null
                          : ((value) => setState(() {
                                _userStatus = value;
                              }))),
                  Padding(
                      padding:
                          EdgeInsets.only(top: 0.02 * constraints.maxHeight)),
                  if (!widget.isInEditingMode)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: Text("Sign Out"),
                          onPressed: () {
                            UserSessionService().logout().then((_) =>
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeScreen()),
                                    (route) => false));
                          }),
                    ),
                  if (widget.isInEditingMode)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            if (_formKey.currentState != null &&
                                _formKey.currentState.validate()) {
                              handleSaveUserInfo();
                            }
                          }),
                    ),
                  if (widget.isInEditingMode)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: Text("Delete"),
                          onPressed: () {
                            handleDeleteUser();
                          }),
                    )
                ],
              ),
            )),
      )),
    );
  }

  Future<void> handleSaveUserInfo() async {
    try {
      await UserService().update(
          userId: widget.userId,
          firstName: _firstNameController.text,
          lastName: _lastNameEditingController.text,
          status: _userStatus.toEntityStatus());

      showSuccessMessage(message: 'User info was updated!');
      Navigator.pop(context);
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }

  Future<void> handleDeleteUser() async {
    try {
      final updatedUser = await UserService().delete(userId: widget.userId);
      setState(() {
        _userStatus = updatedUser.status.string;
      });
      showSuccessMessage(message: 'User was successfully set to deleted.');
      Navigator.of(context).pop();
    } catch (ex) {
      showErrorMessage(message: ex.toString());
    }
  }
}
