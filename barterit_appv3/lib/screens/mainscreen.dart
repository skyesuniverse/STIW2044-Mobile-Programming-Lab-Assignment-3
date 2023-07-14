import 'package:barterit_appv3/models/user.dart';
import 'package:barterit_appv3/screens/hometabscreen.dart';
import 'package:barterit_appv3/screens/profilescreen.dart';
import 'package:barterit_appv3/screens/profiletabscreen.dart';
import 'package:barterit_appv3/screens/sellertabscreen.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";

  @override
  void initState() {
    super.initState();
    print("Home");
    tabchildren = [
      HomeTabScreen(user: widget.user),
      SellerTabScreen(user: widget.user),
      // ProfileTabScreen(user: widget.user),
      widget.user.id.toString() == "na"
          ? const ProfileScreen()
          : ProfileTabScreen(user: widget.user)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabchildren[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_rounded,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.sell,
                  ),
                  label: "Seller"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: "Profile"),
            ]));
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "Seller";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
