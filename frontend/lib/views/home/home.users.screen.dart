import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:foodz/models/user.model.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/models/status.model.dart';
import 'package:foodz/services/user.service.dart';
import 'package:foodz/views/home/home.profile.screen.dart';

class UsersScreen extends StatefulWidget {
  UsersScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  static const _itemsPerPage = 10;

  final _pageLoadController =
      PagewiseLoadController(pageSize: _itemsPerPage, pageFuture: getAllUsers);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Scaffold(
            body: SafeArea(
                child: Padding(
                    child: _build(context, constraints),
                    padding: EdgeInsets.only(
                        left: 0.03 * constraints.maxWidth,
                        right: 0.03 * constraints.maxWidth)))));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    final additionalListItems = [
      Padding(
          child:
              Text("All Users", style: Theme.of(context).textTheme.headline6),
          padding: EdgeInsets.all(4.0))
    ];
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        _pageLoadController.reset();
        return await Future.value({});
      },
      child: PagewiseListView(
          physics: AlwaysScrollableScrollPhysics(),
          pageLoadController: _pageLoadController,
          itemBuilder: (context, user, itemIndex) {
            final userItem = _createUserCard(context, constraints, user);
            if (itemIndex == 0) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [...additionalListItems, userItem]);
            }
            return userItem;
          },
          loadingBuilder: (context) => CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              backgroundColor: Theme.of(context).primaryColor)),
    );
  }

  Widget _createUserCard(
      BuildContext context, BoxConstraints constraints, User user) {
    return Card(
        child: Stack(
      children: [
        _createCardContent(context, constraints, user),
        Positioned.fill(
            child: new Material(
                color: Colors.transparent,
                child: new InkWell(onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              userId: user.id, isInEditingMode: true)));

                  if (this.mounted) {
                    setState(() {
                      _pageLoadController.reset();
                    });
                  }
                })))
      ],
    ));
  }

  Widget _createCardContent(
      BuildContext context, BoxConstraints constraints, User user) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.account_box_rounded, size: 60),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.firstName} ${user.lastName}',
            style: Theme.of(context).textTheme.subtitle1,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
            textAlign: TextAlign.left,
          ),
          Text(
            'Email: ${user.email}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
          Text(
            'Role: ${user.role.string}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
          Text(
            'Status: ${user.status.string}',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.left,
          ),
        ],
      )
    ]);
  }

  static Future<List<User>> getAllUsers(int pageNumber) async {
    return UserService()
        .getAll(pageNumber: pageNumber, itemsPerPage: _itemsPerPage);
  }
}
