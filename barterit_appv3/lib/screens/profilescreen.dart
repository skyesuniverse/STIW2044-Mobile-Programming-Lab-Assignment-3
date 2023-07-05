import 'package:barterit_appv2/screens/loginscreen.dart';
import 'package:barterit_appv2/screens/registrationscreen.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Widget> tabchildren;

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
                          'Guest',
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text('na'),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 40.0, left: 40.0, top: 0),
                  child: ElevatedButton(
                    onPressed: onLogin,
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(25.0),
                        // side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 40.0, left: 40.0, top: 0),
                  child: TextButton(
                    onPressed: onRegister,
                    child: const Text(
                      'Registration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                        EdgeInsets.only(top: 8, bottom: 5),
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onRegister() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (content) => const RegistrationScreen()));
  }

  void onLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (content) => const LoginScreen()));
  }
}
