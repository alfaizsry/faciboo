import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/image_item.dart';
import 'package:faciboo/components/image_picker_handler.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/components/view_photo.dart';
import 'package:faciboo/screens/detail_facility.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class DetailRequestBooking extends StatefulWidget {
  const DetailRequestBooking({
    Key key,
    @required this.idBooking,
    this.isOwner = false,
    @required this.onPop,
  }) : super(key: key);

  final String idBooking;
  final bool isOwner;
  final Function onPop;

  @override
  State<DetailRequestBooking> createState() => _DetailRequestBookingState();
}

class _DetailRequestBookingState extends State<DetailRequestBooking>
    with TickerProviderStateMixin, ImagePickerListener {
  HttpService http = HttpService();
  bool _isLoading = false;

  dynamic detailRequestBooking = {};

  AnimationController _controller;
  ImagePickerHandler imagePicker;

  ImageItem proofPaymentPhoto;

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
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

        proofPaymentPhoto = ImageItem(
          file: _image,
          base64Image: base64Image,
          byestsImg: byestsImg,
        );
      },
    );
  }

  _callGetData() async {
    await _getDetailRequestBooking();
    // if (!isOwner) await _getDetailOwnerBank();
  }

  _getDetailRequestBooking() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "bookingId": widget.idBooking,
    };

    String endpoint = widget.isOwner
        ? "booking/get-detail-merchant-booking"
        : "booking/get-detail-user-booking";

    await http.post(endpoint, body: body).then((res) {
      if (res["success"]) {
        setState(() {
          detailRequestBooking = res["data"];
        });
        print("================DETAILREQUESTBOOKING $detailRequestBooking");
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-detail-merchant-booking $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  _postOwnerConfirmBooking() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "bookingId": widget.idBooking,
    };
    await http.post('booking/confirm-booking', body: body).then((res) {
      if (res["success"]) {
        Navigator.pop(context);
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          // borderRadius: BorderRadius.circular(8),
          backgroundColor: Colors.green[600],
          message: res["msg"],
          duration: const Duration(seconds: 3),
        ).show(context);
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
      print("ERROR booking/confirm-booking $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  // _postPaymentProofBooking() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   Map body = {
  //     "bookingId": widget.idBooking,
  //   };
  //   await http.post('booking/confirm-booking', body: body).then((res) {
  //     if (res["success"]) {
  //       Navigator.pop(context);
  //       Flushbar(
  //         margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
  //         flushbarPosition: FlushbarPosition.TOP,
  //         // borderRadius: BorderRadius.circular(8),
  //         backgroundColor: Colors.green[600],
  //         message: res["msg"],
  //         duration: const Duration(seconds: 3),
  //       ).show(context);
  //     } else {
  //       Flushbar(
  //         margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
  //         flushbarPosition: FlushbarPosition.TOP,
  //         // borderRadius: BorderRadius.circular(8),
  //         backgroundColor: Colors.red,
  //         message: res["msg"],
  //         duration: const Duration(seconds: 3),
  //       ).show(context);
  //     }
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }).catchError((err) {
  //     print("ERROR booking/confirm-booking $err");
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: (widget.isOwner) ? _buildConfirmBooking() : null,
      body: LoadingFallback(
        isLoading: _isLoading,
        child: ListView(
          children: [
            _buildAppbar(),
            const SizedBox(
              height: 30,
            ),
            // _buildHeader(),
            // const SizedBox(
            //   height: 16,
            // ),
            // (requestBookingList.isNotEmpty)
            //     ? _buildRequestBookingList()
            //     : EmptyFacilities(
            //         message: "There are no booking request",
            //       ),

            if (detailRequestBooking["facility"] != null)
              _buildFacilityBooked(),
            if (detailRequestBooking["booking"] != null) _buildDetailBooked(),
            if (widget.isOwner && detailRequestBooking["proofPayment"] != null)
              _buildProofPayment(),
            if (!widget.isOwner &&
                detailRequestBooking["booking"] != null &&
                detailRequestBooking["booking"]["status"] == 0)
              _buildUploadProofPayment(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmBooking() {
    return BottomAppBar(
      child: Container(
        height: 98,
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 32,
        ),
        width: MediaQuery.of(context).size.width,
        child: CustomButton(
          textButton: "Confirm Booking",
          onClick: () {
            _postOwnerConfirmBooking();
          },
        ),
      ),
    );
  }

  Widget _buildUploadProofPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle(title: "Proof of Payment"),
        _buildSubtitle(
          title: "Owner Bank Detail",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
        _buildDetail(
          title: "Bank",
          value: 'BCA',
        ),
        _buildDetail(
          title: "Account Name",
          value: 'SIUUU',
        ),
        _buildDetail(
          title: "Account Number",
          value: '666666666666',
        ),
        SizedBox(
          height: 12,
        ),
        _buildSubtitle(
          title: "Upload Photo Proof Payment",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
        _buildPhotoProofPayment(),
        SizedBox(
          height: 20,
        ),
        _buildButtonUploadCancel(),
        SizedBox(
          height: 32,
        ),
      ],
    );
  }

  Widget _buildButtonUploadCancel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              textButton: "Upload",
              onClick: () {},
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: CustomButton(
              textButton: "Cancel Booking",
              colorButton: Colors.red[700],
              onClick: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoProofPayment() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          proofPaymentPhoto != null
              ? Container(
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(proofPaymentPhoto.byestsImg),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                )
              : Container(
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
          Container(
            width: width,
            height: width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onTap: () {
                imagePicker.showDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.white),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  // color: Colors.blue.withOpacity(0.4),
                ),
                child: Text(
                  (proofPaymentPhoto != null) ? "Change Photo" : "Add Photo",
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
    );
  }

  Widget _buildProofPayment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle(title: "Proof of Payment"),
        _buildDetail(
          title: "Bank",
          value: detailRequestBooking["proofPayment"]["nameBank"],
        ),
        _buildDetail(
          title: "Account Name",
          value: detailRequestBooking["proofPayment"]["name"],
        ),
        _buildDetail(
          title: "Account Number",
          value: detailRequestBooking["proofPayment"]["nomorRekening"],
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPhoto(
                  url: detailRequestBooking["proofPayment"]["imageUrl"],
                ),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: CachedNetworkImage(
              imageUrl: detailRequestBooking["proofPayment"]["imageUrl"] ??
                  "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
              imageBuilder: (context, imageProvider) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return Container(
                  width: 100.0,
                  height: 100.0,
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
        ),
      ],
    );
  }

  Widget _buildFacilityBooked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle(title: "Booked Facility"),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          height: 175,
          child: FacilityBanner(
            detailFacility: detailRequestBooking["facility"],
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailFacility(
                    idFacility: detailRequestBooking["facility"]["_id"],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  List<Map> status = [
    {
      "status": "Waiting Payment",
      "color": Colors.orange,
    },
    {
      "status": "On Booking",
      "color": Colors.green,
    },
    {
      "status": "Done",
      "color": Colors.blue,
    },
  ];

  Widget _buildDetailBooked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle(title: "Detail Booked"),
        _buildDetail(
          title: "Status",
          value: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: status[detailRequestBooking["booking"]["status"]]["color"],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status[detailRequestBooking["booking"]["status"]]["status"],
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        _buildDetail(
          title: "Date",
          value: (detailRequestBooking["booking"]["bookingDate"].toString()) +
              "/" +
              (detailRequestBooking["booking"]["bookingMonth"].toString()) +
              "/" +
              (detailRequestBooking["booking"]["bookingYear"].toString()),
        ),
        _buildDetail(
          title: "Invoice",
          value: detailRequestBooking["booking"]["invoice"],
        ),
        _buildDetail(
          title: "Booking Hours",
          value: Column(
            children: [
              for (var i = 0;
                  i < detailRequestBooking["booking"]["bookingHour"].length;
                  i++)
                Text(
                  detailRequestBooking["booking"]["bookingHour"][i],
                  style: TextStyle(color: Colors.grey.shade800),
                ),
            ],
          ),
        ),
        _buildDetail(
            title: "Total Price",
            value: "Rp${detailRequestBooking["booking"]["total"].toString()}"),
        SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildDetail({@required String title, @required value}) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(color: Colors.grey.shade800),
            ),
            margin: EdgeInsets.only(
              right: 16,
            ),
          ),
          if (value is String)
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),
          if (value is Widget) value
        ],
      ),
    );
  }

  Widget _buildSubtitle({
    @required String title,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    Color color = Colors.black,
  }) {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return Container(
      margin: const EdgeInsets.only(
        top: 32,
        left: 24,
        right: 24,
      ),
      child: Row(
        children: [
          CustomArrowBack(
            onClick: () {
              widget.onPop() ??
                  () {
                    Navigator.pop(context);
                  };
            },
          ),
          SizedBox(
            width: 24,
          ),
          Flexible(
            child: Text(
              "Detail Request Booking",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
