import 'package:barterit_appv2/models/user.dart';
import 'package:barterit_appv2/screens/loginscreen.dart';
import 'package:barterit_appv2/screens/registrationscreen.dart';
import 'package:barterit_appv2/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;

  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  String maintitle = 'Profile';
  late double screenHeight, screenWidth, cardwitdh;

  @override
  void initState() {
    super.initState();
    print('Profile');
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _gotologout();
                },
                child: const Icon(
                  Icons.logout_rounded,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              height: screenHeight * 0.5,
              width: screenWidth,
              child: Card(
                child: Column(children: [
                  const Text(
                    "Profile info",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.all(4),
                    width: screenWidth * 0.4,
                    child: Image.asset(
                      "assets/images/profile.png",
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Column(
                      children: [
                        Text(
                          widget.user.name.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(widget.user.email.toString()),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _gotologout() async {
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Logging out"),
          content: Text("Are your sure?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('email', '');
                await prefs.setString('pass', '');
                print("LOGOUT");
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SplashScreen()));
              },
            ),
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
