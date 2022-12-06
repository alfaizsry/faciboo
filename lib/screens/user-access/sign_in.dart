import 'dart:io';

import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/components/shared_preferences.dart';
import 'package:faciboo/screens/home.dart';
import 'package:faciboo/screens/user-access/forgot_password.dart';
import 'package:faciboo/screens/user-access/sign_up.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  HttpService http = HttpService();
  bool isLoading = false;
  bool statusClose = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('faciboo');

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();

  bool _isObscure = true;

  _callPostApi() {
    setState(() {
      isLoading = true;
    });

    Map body = {"phoneNumber": phoneNumber.text, "password": password.text};

    http.post('user/login', body: body).then((res) {
      print("BODY $body");
      if (res['success']) {
        print("RES LOGIN $res");
        // Flushbar(
        //   margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        //   flushbarPosition: FlushbarPosition.TOP,
        //   // borderRadius: BorderRadius.circular(8),
        //   backgroundColor: Colors.green[600],
        //   message: 'Login Success',
        //   duration: const Duration(seconds: 3),
        // ).show(context);
        String dataAuth = res['token'].toString();
        setState(() {
          isLoading = false;
          storage.setItem("authKey", dataAuth);
          setInstanceString("authKey", dataAuth);
        });
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          // borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.green[600],
          message: res['msg'],
          duration: const Duration(seconds: 3),
        ).show(context);
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((onError) {
      Flushbar(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        flushbarPosition: FlushbarPosition.TOP,
        // borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.green[600],
        message: onError.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
      setState(() {
        isLoading = false;
      });
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
                horizontal: MediaQuery.of(context).size.width * 0.35, vertical: 10),
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
      child: LoadingFallback(
        isLoading: isLoading,
        child: Scaffold(
          key: _key,
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              _buildCover(),
              const SizedBox(
                height: 25,
              ),
              _buildContent(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover() {
    var height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF0FFF9),
      ),
      height: height * 0.4,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 64),
        child: Image.asset(
          'assets/images/coverSign.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Log In",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Phone Number",
              controller: phoneNumber,
              isEnable: true,
              keyboardType: TextInputType.phone,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInputPassword(
              hintText: "Password",
              controller: password,
              isEnable: true,
              keyboardType: TextInputType.text,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
              );
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(
                color: Color(0xFF6B6B6B),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  _callPostApi();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF24AB70),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 89, vertical: 10),
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Text(
                  "or",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/googleLogo.png',
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    const Text(
                      "Login With Google",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Color(0xFF9C9C9C),
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                width: 21,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color(0xFF004D34), fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _customTextInput({
    @required String hintText,
    @required TextEditingController controller,
    Widget prefixIcon,
    Widget suffixIcon,
    bool isEnable = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      enabled: isEnable,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: (isEnable) ? Colors.black : Colors.black54,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        // isDense: true, //remove default padding/ activate bg color
        // hintText: widget.hintText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFFB4B4B4),
        ),
        prefix: prefixIcon,
        prefixIconConstraints: const BoxConstraints(maxWidth: 100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF004D34),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF004D34),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF004D34),
            width: 0.8,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _customTextInputPassword({
    @required String hintText,
    @required TextEditingController controller,
    Widget prefixIcon,
    Widget suffixIcon,
    bool isEnable = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      enabled: isEnable,
      obscureText: _isObscure,
      style: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: (isEnable) ? Colors.black : Colors.black54,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        // isDense: true, //remove default padding/ activate bg color
        // hintText: widget.hintText,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFFB4B4B4),
        ),
        prefix: prefixIcon,
        prefixIconConstraints: const BoxConstraints(maxWidth: 100),
        suffixIcon: IconButton(
            icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            }),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF004D34),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF004D34),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF004D34),
            width: 0.8,
          ),
        ),
      ),
    );
  }
}
