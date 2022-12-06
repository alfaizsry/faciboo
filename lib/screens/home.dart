import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:faciboo/screens/home_page.dart';
import 'package:faciboo/screens/my_booked_page.dart';
import 'package:faciboo/screens/my_facilities_page.dart';
import 'package:faciboo/screens/profile_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 1;
  bool statusClose = false;

  List pages = [
    const MyFacilitiesPage(),
    const HomePage(),
    const MyBookedPage(),
    const ProfilePage(),
  ];

  void close() {
    var duration = const Duration(seconds: 2);
    Timer(duration, () {
      statusClose = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (statusClose == true) {
          exit(0);
        }
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 10),
            padding: const EdgeInsets.all(2),
            decoration:
                BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
            child: const Text(
              "Press again to exit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        statusClose = true;
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: buildBottomNavigationBar(),
        body: pages[_page],
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return CurvedNavigationBar(
      animationDuration: const Duration(
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
