import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:faciboo/screens/home.dart';
import 'package:faciboo/screens/splash_screen.dart';
import 'package:faciboo/screens/user-access/sign_in.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<ConnectivityResult> _connectivityPlus;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> navigatorKeys = GlobalKey<NavigatorState>();
  BuildContext dialogContext;

  @override
  BuildContext get context => dialogContext;

  @override
  void initState() {
    super.initState();
    _connectivityPlus = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (ConnectivityResult.none == result) {
        print('==== result no network');
        //TODO fixing alert dialog

        // Helper(context: navigatorKey.currentContext)
        //     .alert(text: 'Please check your internet connection!');
      } else if (ConnectivityResult.mobile == result) {
        print('==== result mobile connectivity');
      } else if (ConnectivityResult.wifi == result) {
        print('==== result wifi connectivity');
      }
    });
  }

  final routes = {
    // '/': (BuildContext context) => new NoPage(),
    '/loginPage': (BuildContext context) => const SignInPage(),
    // '/splashScreen': (BuildContext context) => const SplashScreen(),
    // '/selesaiforgotPage': (BuildContext context) => new SelesaiforgotPage(),
    // '/onboarding': (BuildContext context) => const OnBoardingScreen(),
    '/home': (BuildContext context) => const Home(),
    '/onSplash': (BuildContext context) => SplashScreenPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: navigatorKeys,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Faciboo',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[400],
        backgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.green[400],
          elevation: 0,
        ),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/onSplash',
      routes: routes,
    );
  }
}
