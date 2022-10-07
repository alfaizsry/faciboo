import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:flutter/material.dart';

class CreateFacilities extends StatefulWidget {
  const CreateFacilities({Key key}) : super(key: key);

  @override
  State<CreateFacilities> createState() => _CreateFacilitiesState();
}

class _CreateFacilitiesState extends State<CreateFacilities> {
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _price = TextEditingController();

  //HALAMAN INI MASIH SEBAGIAN (ONPROGRESS)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 48,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 24),
                child: CustomArrowBack(
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          _buildHeader(),
          SizedBox(
            height: 20,
          ),
          _buildFacilityForm(),
        ],
      ),
    );
  }

  Widget _buildFacilityForm() {
    List<String> formTitle = ["Name", "Description", "Address", "Price/Book"];
    List<TextEditingController> controller = [_name, _desc, _address, _price];

    return Column(
      children: [
        for (var i = 0; i < formTitle.length; i++)
          Container(
              margin: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 12,
              ),
              child: _customTextInput(
                  hintText: formTitle[i], controller: controller[i]))
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Text(
        "Create Facilty",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
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
