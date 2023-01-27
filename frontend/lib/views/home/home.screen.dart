import 'package:flutter/material.dart';
import 'package:foodz/models/user.role.model.dart';
import 'package:foodz/services/user.session.service.dart';
import 'package:foodz/views/home/home.profile.screen.dart';
import 'package:foodz/views/home/home.restaurants.screen.dart';
import 'package:foodz/views/home/home.users.screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => _build(context, constraints));
  }

  Widget _build(BuildContext context, BoxConstraints constraints) {
    return Scaffold(
        body: _screenFromSelectionIndex(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            if (UserSessionService().role == UserRole.ADMIN)
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Users',
              ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }

  Widget _screenFromSelectionIndex(int selectionIndex) {
    switch (selectionIndex) {
      case 0:
        return RestaurantsScreen();
      case 1:
        if (UserSessionService().role != UserRole.ADMIN) {
          return ProfileScreen(userId: UserSessionService().userId);
        }
        return UsersScreen();
      case 2:
        if (UserSessionService().role == UserRole.ADMIN) {
          return ProfileScreen(userId: UserSessionService().userId);
        }
        return null;
      default:
        return Container();
    }
  }
}
