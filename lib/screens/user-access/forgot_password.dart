import 'package:faciboo/screens/user-access/sign_in.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
          );
        },
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFF24AB70), shape: BoxShape.circle),
          padding: const EdgeInsets.all(16),
          child: const Icon(
            Icons.arrow_forward,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
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
            "Forget Password",
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
              hintText: "Enter Your Email Address",
              controller: _email,
              isEnable: true,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: const EdgeInsets.only(
                  left: 15,
                  right: 10,
                ),
                child: const Icon(
                  Icons.mail,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Flexible(
                flex: 1,
                child: Text(
                  "*",
                  style: TextStyle(
                    color: Color(0xFFFF2B00),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Flexible(
                  flex: 6,
                  child: Text(
                    "We will send you a message to set or reset your new password",
                    style: TextStyle(color: Color(0xFF858484), fontSize: 14),
                  ))
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF24AB70),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: const Text(
                "SEND CODE",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
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
        prefixIcon: prefixIcon,
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
}
