import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/image_item.dart';
import 'package:faciboo/components/image_picker_handler.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/dummy_data/dummy_api.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as httpDart;

class EditFacilities extends StatefulWidget {
  const EditFacilities({
    Key key,
    @required this.idFacility,
  }) : super(key: key);

  final String idFacility;

  @override
  State<EditFacilities> createState() => _EditFacilitiesState();
}

class _EditFacilitiesState extends State<EditFacilities>
    with TickerProviderStateMixin, ImagePickerListener {
  HttpService http = HttpService();
  TextEditingController _name = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _urlMaps = TextEditingController();
  TextEditingController _bookingHours = TextEditingController();

  List<dynamic> imageLoadLinkList = [];
  List<String> removedImageIdLoad = [];

  List<ImageItem> imageItemList = [];
  List<String> imageArrBase64List = [];
  List<File> imageFileList = [];
  List categories = [];

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  var dummyApi = DummyApi();
  bool _isLoading = false;

  String selectedCategory = "";
  dynamic detailFacility = {};

  @override
  void initState() {
    // TODO: implement initState
    _callGetData();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    imagePicker = new ImagePickerHandler(this, _controller);
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
        Uint8List byestsImg = Base64Decoder().convert(base64Image);

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

  Future<String> networkImageToBase64(String imageUrl) async {
    httpDart.Response response = await httpDart.get(Uri.parse(imageUrl));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  _callGetData() async {
    // setState(() {
    //   categories = dummyApi.getCategoryList["data"];
    // });
    _getCategories();
    _getDetailFacility();
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

  _getDetailFacility() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "id": widget.idFacility,
    };
    await http.post('facility/get-detail-facility', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          detailFacility = res["data"];
        });
        print("================DETAIL FACILITY $detailFacility");
        _setDataForm();
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR detail-facility $err");

      setState(() {
        _isLoading = false;
      });
    });
  }

  _setDataForm() {
    String hoursAvailable = "";

    for (var i = 0; i < detailFacility["hourAvailable"].length; i++) {
      if (i > 0) hoursAvailable += ",";
      hoursAvailable += detailFacility["hourAvailable"][i];
    }

    setState(() {
      imageLoadLinkList = detailFacility["image"];
      selectedCategory = detailFacility["categoryId"];
      _name.text = detailFacility["name"];
      _desc.text = detailFacility["description"];
      _address.text = detailFacility["address"];
      _price.text = detailFacility["price"].toString();
      _urlMaps.text = detailFacility["urlMaps"];
      _bookingHours.text = hoursAvailable;
    });
  }

  _postEditFacility() async {
    setState(() {
      _isLoading = true;
    });

    // for (var i = 0; i < detailFacility["image"].length; i++) {
    //   imageArrBase64List
    //       .add(networkImageToBase64(detailFacility["image"][i]).toString());
    // }

    List<String> bookingHoursList = _bookingHours.text.split(",");
    print(
        "============IMAGEBASE64LIST${imageArrBase64List.length} $imageArrBase64List");
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
    await http.post('facility/edit-facility', body: body).then((res) {
      if (res["success"]) {
        setState(() {
          Navigator.pop(context);
          Flushbar(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            flushbarPosition: FlushbarPosition.TOP,
            // borderRadius: BorderRadius.circular(8),
            backgroundColor: Colors.green[600],
            message: res["msg"] ?? "Success Edit Facility",
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
          message: res["msg"] ?? "Failed Edit Facility",
          duration: const Duration(seconds: 3),
        ).show(context);
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR edit-facility $err");
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
                textButton: "Edit",
                onClick: () {
                  _postEditFacility();
                },
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
    List<String> formTitle = [
      "Name",
      "Description",
      "Address",
      "Price/Book",
      "Maps Links",
    ];
    List<TextEditingController> controller = [
      _name,
      _desc,
      _address,
      _price,
      _urlMaps,
    ];

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
          ),
          SizedBox(
            height: 20,
          ),
          _buildEmptyImageList(),
          SizedBox(
            height: 16,
          ),
          if (imageLoadLinkList.isNotEmpty || imageItemList.isNotEmpty)
            _buildListImageCard(),
        ],
      ),
    );
  }

  Widget _buildListImageCard() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < imageLoadLinkList.length; i++)
            _imageCard(index: i, image: imageLoadLinkList[i], type: "url"),
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
      margin: EdgeInsets.only(
        right: 12,
      ),
      alignment: Alignment.topRight,
      padding: EdgeInsets.all(6),
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        image: (type == "uint8list")
            ? DecorationImage(image: MemoryImage(image), fit: BoxFit.cover)
            : DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            if (type == "uint8list") {
              imageItemList.removeAt(index);
              imageFileList.removeAt(index);
              imageArrBase64List.removeAt(index);
            } else {
              imageLoadLinkList.removeAt(index);
              // removedImageIdLoad.add(value);
            }
          });
        },
        child: Icon(
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
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: DottedBorder(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 24,
          ),
          color: Colors.blue,
          borderType: BorderType.RRect,
          radius: Radius.circular(10),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo_rounded),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Facility Photos",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
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
        "Edit Facilty",
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
