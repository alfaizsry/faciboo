import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  HttpService http = HttpService();
  var dummyApi = DummyApi();
  dynamic userDetail = {};

  bool _isLoading = false;
  bool _isEditing = false;
  bool _isObsPassword = true;

  TextEditingController _name = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _bankName = TextEditingController();
  TextEditingController _bankAccountName = TextEditingController();
  TextEditingController _bankAccountNumber = TextEditingController();

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    // setState(() {
    //   userDetail = dummyApi.getuserdetail["data"];
    // });
    _getProfile();
  }

  _getProfile() async {
    setState(() {
      _isLoading = true;
    });
    await http.post('profile/get-profile').then((res) {
      if (res["success"]) {
        setState(() {
          userDetail = res["data"];
          _setDataForm();
        });
        print("================USERDETAIL $userDetail");
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-profile $err");

      setState(() {
        _isLoading = false;
      });
    });
  }

  _editProfile() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "name": _name.text,
      "password": _newPassword.text,
      "nameBank": _bankName.text,
      "nomorRekening": _bankAccountNumber.text,
      "nameAccountBank": _bankAccountName.text,
    };
    await http.post('profile/edit-profile', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          _newPassword.text = "";
          _isEditing = false;
          _isObsPassword = true;
        });
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          // borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.green[600],
          message: res["msg"],
          duration: const Duration(seconds: 3),
        ).show(context);
        _getProfile();
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR edit-profile $err");

      setState(() {
        _isLoading = false;
      });
    });
  }

  _setDataForm() {
    setState(() {
      _name.text = userDetail["name"] ?? "";
      _email.text = userDetail["email"] ?? "";
      _phone.text = userDetail["phoneNumber"] ?? "";
      _location.text = "userDetail['location']" ?? "";
      _bankAccountName.text = userDetail["nameAccountBank"] ?? "";
      _bankAccountNumber.text = userDetail["nomorRekening"] ?? "";
      _bankName.text = userDetail["nameBank"] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: _isLoading,
      child: Container(
        child: ListView(
          children: [
            SizedBox(
              height: 48,
            ),
            _buildHeaderProfile(),
            SizedBox(
              height: 24,
            ),
            _buildUserDetailForm(),
            if (_isEditing)
              Column(
                children: [
                  _buildButton(),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            SizedBox(
              height: 48,
            ),
            Container(
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: CustomButton(
                textButton: "Sign Out",
                onClick: () {
                  Navigator.pushReplacementNamed(context, '/loginPage');
                },
                colorButton: Colors.red[900],
              ),
            ),
            SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderProfile() {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: userDetail["imageUrl"] ??
              "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
          imageBuilder: (context, imageProvider) => Container(
            width: 144.0,
            height: 144.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          errorWidget: (context, url, error) {
            return Container(
              width: 144.0,
              height: 144.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(
            top: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${userDetail["name"]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              if (!_isEditing)
                InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.green[700],
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSubtitle({@required String subtitle}) {
    return Text(
      "$subtitle",
      style: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUserDetailForm() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(subtitle: "Name"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Name",
              controller: _name,
              isEnable: _isEditing,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Email"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Email",
              controller: _email,
              isEnable: _isEditing,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.email,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Phone"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Phone",
              controller: _phone,
              isEnable: _isEditing,
              keyboardType: TextInputType.number,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.phone,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "New Password"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "New Password",
              controller: _newPassword,
              isPassword: _isObsPassword,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              suffixIcon: Container(
                margin: EdgeInsets.only(right: 8),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObsPassword = !_isObsPassword;
                      });
                    },
                    icon: Icon(
                      _isObsPassword
                          ? Icons.visibility_off_rounded
                          : Icons.remove_red_eye_rounded,
                    )),
              ),
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.password_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // _buildSubtitle(subtitle: "Location"),
          // Container(
          //   margin: EdgeInsets.only(
          //     top: 4,
          //     bottom: 16,
          //   ),
          //   child: _customTextInput(
          //     hintText: "Location",
          //     controller: _location,
          //     isEnable: _isEditing,
          //     keyboardType: TextInputType.multiline,
          //     prefixIcon: Container(
          //       margin: EdgeInsets.only(
          //         right: 10,
          //       ),
          //       child: Icon(
          //         Icons.share_location_rounded,
          //         size: 18,
          //         color: Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          _buildSubtitle(subtitle: "Bank Name"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Bank Name",
              controller: _bankName,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.money,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Bank Account Name"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Bank Account Name",
              controller: _bankAccountName,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Bank Account Number"),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Bank Account Number",
              controller: _bankAccountNumber,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Row(
        children: [
          CustomButton(
            textButton: "Save",
            onClick: () {
              _editProfile();
            },
          ),
          SizedBox(
            width: 12,
          ),
          CustomButton(
            textButton: "Cancel",
            colorButton: Colors.red[700],
            onClick: () {
              setState(() {
                _isEditing = false;
              });
              _setDataForm();
            },
          ),
        ],
      ),
    );
  }

  Widget _customTextInput({
    @required String hintText,
    @required TextEditingController controller,
    Widget prefixIcon,
    Widget suffixIcon,
    bool isPassword = false,
    bool isEnable = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPassword,
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
        // isDense: true, //remove default padding
        fillColor: Colors.green[50],
        filled: true, // activate bg color
        // hintText: widget.hintText,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: isEnable ? Colors.black : Colors.black54,
        ),
        prefix: prefixIcon,
        prefixIconConstraints: BoxConstraints(maxWidth: 100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.yellow,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 0.8,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue[800],
            width: 0.8,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
