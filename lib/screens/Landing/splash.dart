import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    Timer(const Duration(seconds: 2), () => initPages());
    super.initState();
  }

  initPages() async {
    final sh = await SharedPreferences.getInstance();
    if (sh.getString('token') != null) {
      Navigator.pushReplacementNamed(context, "home");
    } else {
      if (sh.getBool('screened') == true) {
        Navigator.pushReplacementNamed(context, "login");
      } else {
        Navigator.pushReplacementNamed(context, "intro");
      }
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width / 3.5,
        ),
      ),
    );
  }
}
