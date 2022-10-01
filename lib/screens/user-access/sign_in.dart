import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/screens/home.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: [
            _buildCover(),
            SizedBox(
              height: 25,
            ),
            _buildContent(),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCover() {
    var height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF0FFF9),
      ),
      height: height * 0.4,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 64),
        child: Image.asset(
          'assets/images/coverSign.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Login",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Username",
              controller: _username,
              isEnable: true,
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Password",
              controller: _password,
              isEnable: true,
              keyboardType: TextInputType.text,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: Color(0xFF6B6B6B),
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF24AB70),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 89, vertical: 10),
                  child: Text(
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
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  "or",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B6B6B),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/googleLogo.png',
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Text(
                        "Login With Google",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Color(0xFF9C9C9C),
                  fontSize: 14,
                ),
              ),
              SizedBox(
                width: 21,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Color(0xFF004D34),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
        // isDense: true, //remove default padding/ activate bg color
        // hintText: widget.hintText,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: Color(0xFFB4B4B4),
        ),
        prefix: prefixIcon,
        prefixIconConstraints: BoxConstraints(maxWidth: 100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFF004D34),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFF004D34),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Color(0xFF004D34),
            width: 0.8,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
