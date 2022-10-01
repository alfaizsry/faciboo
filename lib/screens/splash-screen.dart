import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/screens/home.dart';
import 'package:faciboo/screens/user-access/sign_in.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 4),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Color(0xFFF0FFF9),
      ),
      child: Image.asset(
        'assets/images/splashImage2.png',
        fit: BoxFit.cover,
      ),
    );
  }
}
