import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/screens/user-access/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:localstorage/localstorage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isObscure = true;
  HttpService http = HttpService();
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final LocalStorage storage = LocalStorage('faciboo');

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  _callPostApi() {
    setState(() {
      isLoading = true;
    });

    Map body = {
      "name": fullName.text,
      "email": email.text,
      "password": password.text,
      "phoneNumber": mobileNumber.text
    };

    http.post('user/register', body: body).then((res) {
      print("BODY $body");
      if (res['success']) {
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: 8,
          backgroundColor: Colors.green[600],
          message: 'Registration Success',
          duration: const Duration(seconds: 3),
        ).show(context);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      } else {
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: 8,
          backgroundColor: Colors.green[600],
          message: res['msg'],
          duration: const Duration(seconds: 3),
        ).show(context);
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: isLoading,
      child: Scaffold(
        key: _key,
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            _buildCover(),
            const SizedBox(
              height: 8,
            ),
            _buildContent(),
            const SizedBox(
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
            "Sign Up",
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
              hintText: "Full Name",
              controller: fullName,
              isEnable: true,
              keyboardType: TextInputType.name,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "E-mail",
              controller: email,
              isEnable: true,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Mobile Number",
              controller: mobileNumber,
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
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInputPassword(
              hintText: "Confirm Password",
              controller: confirmPassword,
              isEnable: true,
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 7,
                  child: InkWell(
                    onTap: () {
                      _callPostApi();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF24AB70),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 69, vertical: 10),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Flexible(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Already have an",
                        style: TextStyle(
                          color: Color(0xFF9C9C9C),
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        "account?",
                        style: TextStyle(
                          color: Color(0xFF9C9C9C),
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInPage()),
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                              color: Color(0xFF004D34),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )),
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
