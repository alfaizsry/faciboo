import 'dart:async';
import 'package:faciboo/components/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final LocalStorage storage = LocalStorage('faciboo');
  @override
  void initState() {
    super.initState();
    startSplashStatic();
  }

  startSplashStatic() async {
    String authKey = await getInstanceString('authKey');
    if (authKey != null && authKey != '') {
      storage.setItem("authKey", authKey);
    }
    Duration duration = const Duration(seconds: 3);
    return Timer(duration, () {
      if (authKey != null && authKey is String && authKey != '') {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/loginPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFF0FFF9),
      ),
      child: Image.asset(
        'assets/images/splashImage2.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
