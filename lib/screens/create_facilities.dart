import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flutter/material.dart';

class CreateFacilities extends StatefulWidget {
  const CreateFacilities({Key key}) : super(key: key);

  @override
  State<CreateFacilities> createState() => _CreateFacilitiesState();
}

class _CreateFacilitiesState extends State<CreateFacilities> {
  HttpService http = HttpService();
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _bookingHours = TextEditingController();

  var dummyApi = DummyApi();
  List categories = [];

  String selectedCategory = "";

  @override
  void initState() {
    // TODO: implement initState
    _callGetData();
    super.initState();
  }

  _callGetData() async {
    setState(() {
      categories = dummyApi.getCategoryList["data"];
    });
    _getCategories();
  }

  _getCategories() async {
    await http.post('category/get-category').then((res) {
      if (res["success"]) {
        setState(() {
          categories = res["data"];
          selectedCategory = categories[0]["_id"];
        });
        print("================CATEGORY $categories");
      }
    }).catchError((err) {
      print("ERROR get-category $err");
    });
  }

  //HALAMAN INI MASIH SEBAGIAN (ONPROGRESS)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: _buildBottomBar(),
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
            height: 32,
          ),
          _buildCategoryPicker(),
          SizedBox(
            height: 20,
          ),
          _buildFacilityForm(),
          SizedBox(
            height: 32,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: CustomButton(
              textButton: "Create",
              onClick: () {},
            ),
          ),
          SizedBox(
            height: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 0.8,
            color: Colors.grey,
          ),
        ),
      ),
      child: CustomButton(
        onClick: () {},
        textButton: "Create",
      ),
    );
  }

  Widget _buildFacilityForm() {
    List<String> formTitle = ["Name", "Description", "Address", "Price/Book"];
    List<TextEditingController> controller = [_name, _desc, _address, _price];

    return Container(
      margin: EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < formTitle.length; i++)
            Container(
              margin: EdgeInsets.only(
                bottom: 16,
              ),
              child: _customTextInput(
                hintText: formTitle[i],
                controller: controller[i],
              ),
            ),
          _customTextInput(
            hintText: "Booking Hours",
            controller: _bookingHours,
          ),
          Container(
            margin: EdgeInsets.only(
              top: 4,
            ),
            child: Text(
              "Notes : separate booking time with commas",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Category",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            physics: ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < categories.length; i++)
                  Container(
                    margin: EdgeInsets.only(
                      right: 12,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[i]["_id"];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: categories[i]["_id"] == selectedCategory
                              ? Colors.green
                              : Colors.grey[350],
                        ),
                        child: Text(
                          categories[i]["name"] ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
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
    bool isEnable = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      enabled: isEnable,
      minLines: 1,
      maxLines: 5,
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
