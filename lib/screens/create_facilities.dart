import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:faciboo/components/custom_alert.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/image_item.dart';
import 'package:faciboo/components/image_picker_handler.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CreateFacilities extends StatefulWidget {
  const CreateFacilities({Key key}) : super(key: key);

  @override
  State<CreateFacilities> createState() => _CreateFacilitiesState();
}

class _CreateFacilitiesState extends State<CreateFacilities>
    with TickerProviderStateMixin, ImagePickerListener {
  HttpService http = HttpService();
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _urlMaps = TextEditingController();
  TextEditingController _bookingHours = TextEditingController();

  List<ImageItem> imageItemList = [];
  List<String> imageArrBase64List = [];
  List<File> imageFileList = [];
  List categories = [];

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  bool _isLoading = false;

  String selectedCategory = "";

  @override
  void initState() {
    // TODO: implement initState
    _callGetData();

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

        // arrBase64.add(base64Image);
        // arrFileName.add(fileName);
        imageArrBase64List.add(base64Image);
        imageFileList.add(_image);
        imageItemList.add(
          ImageItem(
            file: _image,
            base64Image: base64Image,
            byestsImg: byestsImg,
          ),
        );
        print("=================ITEMITEMLIST $imageItemList");
        print("=================BASE64 $base64Image");
        print("=================UINT8LIST $byestsImg");
      },
    );
  }

  _callGetData() async {
    _getCategories();
  }

  _getCategories() async {
    setState(() {
      _isLoading = true;
    });
    await http.post('category/get-category').then((res) {
      if (res["success"]) {
        setState(() {
          categories = res["data"];
          selectedCategory = categories[0]["_id"];
        });
        print("================CATEGORY $categories");
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-category $err");

      setState(() {
        _isLoading = false;
      });
    });
  }

  _postCreateFacility() async {
    setState(() {
      _isLoading = true;
    });
    List<String> bookingHoursList = _bookingHours.text.split(",");
    print("============IMAGEFILELIST$imageFileList");
    print("============BOOKINGHOURSLIST$bookingHoursList");
    Map body = {
      "name": _name.text,
      "address": _address.text,
      "description": _desc.text,
      "price": int.parse(_price.text),
      "urlMaps": _urlMaps.text,
      "categoryId": selectedCategory,
      "image": imageArrBase64List,
      "hourAvailable": bookingHoursList,
    };
    print("============BODY$body");
    await http.post('facility/add-facility', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          Navigator.pop(context);
          Flushbar(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            flushbarPosition: FlushbarPosition.TOP,
            // borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.green[600],
            message: res["msg"],
            duration: const Duration(seconds: 3),
          ).show(context);
        });
        print("================CATEGORY $categories");
      } else {
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          // borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.red,
          message: res["msg"],
          duration: const Duration(seconds: 3),
        ).show(context);
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-category $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  //HALAMAN INI MASIH SEBAGIAN (ONPROGRESS)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: _buildBottomBar(),
      body: LoadingFallback(
        isLoading: _isLoading,
        child: ListView(
          children: [
            const SizedBox(
              height: 48,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: CustomArrowBack(
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            _buildHeader(),
            const SizedBox(
              height: 32,
            ),
            _buildCategoryPicker(),
            const SizedBox(
              height: 20,
            ),
            _buildFacilityForm(),
            const SizedBox(
              height: 32,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: CustomButton(
                textButton: "Create",
                onClick: () {
                  (_name.text.isNotEmpty &&
                          _address.text.isNotEmpty &&
                          _desc.text.isNotEmpty &&
                          _price.text.isNotEmpty &&
                          _urlMaps.text.isNotEmpty &&
                          selectedCategory.isNotEmpty &&
                          imageArrBase64List.isNotEmpty &&
                          _bookingHours.text.isNotEmpty)
                      ? _postCreateFacility()
                      : CustomAlert(context: context)
                          .alertDialog(text: "Please fill out all forms");
                },
              ),
            ),
            const SizedBox(
              height: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
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
    List<String> formTitle = [
      "Name",
      "Description",
      "Address",
      "Price/Book",
      "Maps Links",
      "Booking Hours",
    ];
    List<TextEditingController> controller = [
      _name,
      _desc,
      _address,
      _price,
      _urlMaps,
      _bookingHours
    ];
    List<Map> form = [
      {
        "title": "Name",
        "controller": _name,
        "hint": "ex: Fordy...",
        "keyboard_type": TextInputType.text,
        "note": "",
      },
      {
        "title": "Description",
        "controller": _desc,
        "hint": "ex : Best facility ever...",
        "keyboard_type": TextInputType.text,
        "note": "",
      },
      {
        "title": "Address",
        "controller": _address,
        "hint": "ex : Jl bersamanya...",
        "keyboard_type": TextInputType.text,
        "note": "",
      },
      {
        "title": "Price/Book",
        "controller": _price,
        "hint": "ex : 25000",
        "keyboard_type": TextInputType.number,
        "note": "",
      },
      {
        "title": "Maps Links",
        "controller": _urlMaps,
        "hint": "ex : https://goo.gl/maps/...",
        "keyboard_type": TextInputType.text,
        "note": "",
      },
      {
        "title": "Booking Hours",
        "controller": _bookingHours,
        "hint": "ex : 20.00-21.00,21.00-22.00",
        "keyboard_type": TextInputType.text,
        "note": "Notes: separate booking time with commas",
      },
    ];

    return Container(
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < form.length; i++)
            Container(
              margin: const EdgeInsets.only(
                bottom: 16,
              ),
              child: _customTextInput(
                placeHolder: form[i]["title"],
                hintText: form[i]["hint"],
                controller: form[i]["controller"],
                keyboardType: form[i]["keyboard_type"],
                note: form[i]["note"],
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          _buildEmptyImageList(),
          const SizedBox(
            height: 16,
          ),
          if (imageItemList.isNotEmpty) _buildListImageCard(),
        ],
      ),
    );
  }

  Widget _buildListImageCard() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < imageItemList.length; i++)
            _imageCard(index: i, image: imageItemList[i].byestsImg)
        ],
      ),
    );
  }

  Widget _imageCard({
    @required int index,
    @required dynamic image,
    String type = "uint8list",
    //type uint8list & url
  }) {
    return Container(
      margin: const EdgeInsets.only(
        right: 12,
      ),
      alignment: Alignment.topRight,
      padding: const EdgeInsets.all(6),
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        image: (type == "uint8list")
            ? DecorationImage(image: MemoryImage(image), fit: BoxFit.cover)
            : NetworkImage(image),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (type == "uint8list") {
              imageItemList.removeAt(index);
              imageFileList.removeAt(index);
              imageArrBase64List.removeAt(index);
            }
          });
        },
        child: const Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildEmptyImageList() {
    return InkWell(
      onTap: () {
        imagePicker.showDialog(context);
        // imagePicker.openCamera();
      },
      child: Container(
        // margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
        decoration: BoxDecoration(
          color: Colors.lightGreen.shade50,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: DottedBorder(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
          color: Colors.blue,
          borderType: BorderType.RRect,
          radius: const Radius.circular(10),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.add_a_photo_rounded),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Facility Photos",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Insert photos of facility",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Category",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            physics: const ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < categories.length; i++)
                  Container(
                    margin: const EdgeInsets.only(
                      right: 12,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[i]["_id"];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: categories[i]["_id"] == selectedCategory
                              ? Colors.green
                              : Colors.grey[350],
                        ),
                        child: Text(
                          categories[i]["name"] ?? "",
                          style: const TextStyle(
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
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: const Text(
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
    String placeHolder = "",
    String note = "",
    Widget prefixIcon,
    Widget suffixIcon,
    bool isEnable = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (placeHolder != "")
          Text(
            placeHolder,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        SizedBox(
          height: 4,
        ),
        TextFormField(
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
              color: isEnable ? Colors.grey : Colors.black54,
            ),
            prefix: prefixIcon,
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
        ),
        if (note != null && note.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 2),
            child: Text(
              note,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }
}
