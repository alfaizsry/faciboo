import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:faciboo/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 1;

  List pages = [
    Container(),
    HomePage(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNavigationBar(),
      body: pages[_page],
    );
  }

  Widget buildBottomNavigationBar() {
    return CurvedNavigationBar(
      animationDuration: Duration(
        milliseconds: 200,
      ),
      animationCurve: Curves.bounceInOut,
      buttonBackgroundColor: Colors.green,
      backgroundColor: Colors.transparent,
      color: Colors.lightGreen[50],
      index: 1,
      height: 60,
      items: <Widget>[
        customIcon(icon: Icons.create_outlined, index: 0),
        customIcon(icon: Icons.home_outlined, index: 1),
        customIcon(icon: Icons.my_library_books_outlined, index: 2),
        customIcon(icon: Icons.person_sharp, index: 3),
      ],
      onTap: (index) {
        //Handle button tap
        setState(() {
          _page = index;
        });
        print("============index $index");
      },
    );
  }

  Widget customIcon({
    int index,
    IconData icon,
  }) {
    return Icon(
      icon,
      size: 25,
      color: (index == _page) ? Colors.white : Colors.green,
    );
  }
}
