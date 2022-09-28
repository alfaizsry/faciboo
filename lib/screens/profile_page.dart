import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var dummyApi = DummyApi();
  dynamic userDetail;

  bool _isEditing = false;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _location = TextEditingController();

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    setState(() {
      userDetail = dummyApi.getuserdetail["data"];
    });
    await _setDataForm();
  }

  _setDataForm() {
    setState(() {
      _name.text = userDetail["name"];
      _email.text = userDetail["email"];
      _phone.text = userDetail["phone"];
      _location.text = userDetail["location"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 30,
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
              onClick: () {},
              colorButton: Colors.red[900],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderProfile() {
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: userDetail["image"],
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
        ),
        Container(
          margin: EdgeInsets.only(
            top: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userDetail["name"],
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

  Widget _buildUserDetailForm() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Name",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
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
          Text(
            "Email",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
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
          Text(
            "Phone",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
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
          Text(
            "Location",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 4,
              bottom: 16,
            ),
            child: _customTextInput(
              hintText: "Location",
              controller: _location,
              isEnable: _isEditing,
              keyboardType: TextInputType.multiline,
              prefixIcon: Container(
                margin: EdgeInsets.only(
                  right: 10,
                ),
                child: Icon(
                  Icons.share_location_rounded,
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
            onClick: () {},
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
    bool isEnable = false,
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
