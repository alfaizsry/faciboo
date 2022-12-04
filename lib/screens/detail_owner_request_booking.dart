import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/facility_banner.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/screens/detail_facility.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class DetailOwnerRequestBooking extends StatefulWidget {
  const DetailOwnerRequestBooking({
    Key key,
    @required this.idBooking,
  }) : super(key: key);

  final String idBooking;

  @override
  State<DetailOwnerRequestBooking> createState() =>
      _DetailOwnerRequestBookingState();
}

class _DetailOwnerRequestBookingState extends State<DetailOwnerRequestBooking> {
  HttpService http = HttpService();
  bool _isLoading = false;

  dynamic detailRequestBooking = {};

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    await _getDetailRequestBooking();
  }

  _getDetailRequestBooking() async {
    setState(() {
      _isLoading = true;
    });
    Map body = {
      "bookingId": widget.idBooking,
    };
    await http
        .post('booking/get-detail-merchant-booking', body: body)
        .then((res) {
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

  _postConfirmBooking() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildConfirmBooking(),
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
            if (detailRequestBooking["proofPayment"] != null)
              _buildProofPayment(),
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
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: 32,
        ),
        width: MediaQuery.of(context).size.width,
        child: CustomButton(
          textButton: "Confirm Booking",
          onClick: () {
            _postConfirmBooking();
          },
        ),
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
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: CachedNetworkImage(
            imageUrl: detailRequestBooking["proofPayment"]["imageUrl"] ??
                "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
            imageBuilder: (context, imageProvider) => Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                ),
              );
            },
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
          margin: const EdgeInsets.symmetric(horizontal: 24),
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
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildDetailBooked() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubtitle(title: "Detail Booked"),
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
                Text(detailRequestBooking["booking"]["bookingHour"][i])
            ],
          ),
        ),
        _buildDetail(
            title: "Total Price",
            value: "Rp${detailRequestBooking["booking"]["total"].toString()}"),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildDetail({@required String title, @required value}) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          if (value is String)
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (value is Widget) value
        ],
      ),
    );
  }

  Widget _buildSubtitle({@required String title}) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
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
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            width: 24,
          ),
          const Flexible(
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
