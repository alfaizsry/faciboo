import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_alert.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/image_item.dart';
import 'package:faciboo/components/image_picker_handler.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/components/view_photo.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin, ImagePickerListener {
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

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  ImageItem newPhotoProfile;

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = ImagePickerHandler(this, _controller);
    imagePicker.init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  userImage(File _image, int type) {
    setState(
      () {
        print("=============MASOKKKK");
        String base64Image =
            _image != null ? base64Encode(_image.readAsBytesSync()) : '';
        String fileName = _image != null ? _image.path.split("/").last : '';
        Uint8List byestsImg = const Base64Decoder().convert(base64Image);

        newPhotoProfile = ImageItem(
          file: _image,
          base64Image: base64Image,
          byestsImg: byestsImg,
        );
      },
    );
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
    Map body = (_newPassword.text != "")
        ? {
            "name": _name.text,
            "address": _location.text,
            "password": _newPassword.text,
            "nameBank": _bankName.text,
            "nomorRekening": _bankAccountNumber.text,
            "nameAccountBank": _bankAccountName.text,
            "image":
                newPhotoProfile != null ? newPhotoProfile.base64Image : null,
          }
        : {
            "name": _name.text,
            "address": _location.text,
            "nameBank": _bankName.text,
            "nomorRekening": _bankAccountNumber.text,
            "nameAccountBank": _bankAccountName.text,
            "image":
                newPhotoProfile != null ? newPhotoProfile.base64Image : null,
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
      _location.text = userDetail['address'] ?? "";
      _bankAccountName.text = userDetail["nameAccountBank"] ?? "";
      _bankAccountNumber.text = userDetail["nomorRekening"] ?? "";
      _bankName.text = userDetail["nameBank"] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingFallback(
      isLoading: _isLoading,
      child: ListView(
        children: [
          const SizedBox(
            height: 48,
          ),
          _buildHeaderProfile(),
          const SizedBox(
            height: 24,
          ),
          _buildUserDetailForm(),
          if (_isEditing)
            Column(
              children: [
                _buildButton(),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          const SizedBox(
            height: 48,
          ),
          Container(
            margin: const EdgeInsets.only(
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
          const SizedBox(
            height: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderProfile() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            newPhotoProfile != null
                ? Container(
                    width: 144.0,
                    height: 144.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(newPhotoProfile.byestsImg),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  )
                : InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPhoto(
                            url: userDetail["imageUrl"],
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
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
                  ),
            if (_isEditing)
              Container(
                width: 144.0,
                height: 144.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    imagePicker.showDialog(context);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                      // color: Colors.blue.withOpacity(0.4),
                    ),
                    child: const Text(
                      "Change Photo",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${userDetail["name"]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
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
      subtitle,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildUserDetailForm() {
    EdgeInsets marginPrefixIcon =
        const EdgeInsets.only(right: 12, left: 16, bottom: 2);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubtitle(subtitle: "Name"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Name",
              controller: _name,
              isEnable: _isEditing,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.person,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Email"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Email",
              controller: _email,
              isEnable: _isEditing,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.email,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Phone"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Phone",
              controller: _phone,
              isEnable: false,
              keyboardType: TextInputType.number,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.phone,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "New Password"),
          Container(
            margin: const EdgeInsets.only(
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
                margin: const EdgeInsets.only(right: 8),
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
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.password_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Location"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Location",
              controller: _location,
              isEnable: _isEditing,
              keyboardType: TextInputType.multiline,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.share_location_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Bank Name"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Bank Name",
              controller: _bankName,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.money,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Bank Account Name"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Bank Account Name",
              controller: _bankAccountName,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          _buildSubtitle(subtitle: "Bank Account Number"),
          Container(
            margin: const EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Bank Account Number",
              controller: _bankAccountNumber,
              isEnable: _isEditing,
              keyboardType: TextInputType.text,
              prefixIcon: Container(
                margin: marginPrefixIcon,
                child: const Icon(
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
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Row(
        children: [
          CustomButton(
            textButton: "Save",
            onClick: () {
              (_name.text.isNotEmpty &&
                      _email.text.isNotEmpty &&
                      _phone.text.isNotEmpty &&
                      _location.text.isNotEmpty &&
                      _bankName.text.isNotEmpty &&
                      _bankAccountName.text.isNotEmpty &&
                      _bankAccountNumber.text.isNotEmpty)
                  ? _editProfile()
                  : CustomAlert(context: context)
                      .alertDialog(text: "Please fill out all forms");
            },
          ),
          const SizedBox(
            width: 12,
          ),
          CustomButton(
            textButton: "Cancel",
            colorButton: Colors.red[700],
            onClick: () {
              setState(() {
                _isEditing = false;
                newPhotoProfile = null;
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        // isDense: true, //remove default padding
        fillColor: Colors.green[50],
        filled: true, // activate bg color
        // hintText: widget.hintText,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14.0,
          color: isEnable ? Colors.blue : Colors.black54,
        ),
        prefixIcon: prefixIcon,
        prefixIconConstraints: const BoxConstraints(maxWidth: 100),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.yellow,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 0.8,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
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
