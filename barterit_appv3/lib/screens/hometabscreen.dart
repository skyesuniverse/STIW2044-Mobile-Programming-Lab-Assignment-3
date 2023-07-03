import 'package:barterit_appv2/models/user.dart';
import 'package:flutter/material.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;

  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  String maintitle = 'Home';

  @override
  void initState() {
    super.initState();
    print('Home');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: Center(
        child: Text(maintitle),
      ),
    );
  }
}
