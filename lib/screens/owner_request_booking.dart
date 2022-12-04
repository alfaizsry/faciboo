import 'package:cached_network_image/cached_network_image.dart';
import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/empty_facilities.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/screens/detail_owner_request_booking.dart';
import 'package:flutter/material.dart';

class OwnerRequestBooking extends StatefulWidget {
  const OwnerRequestBooking({Key key}) : super(key: key);

  @override
  State<OwnerRequestBooking> createState() => _OwnerRequestBookingState();
}

class _OwnerRequestBookingState extends State<OwnerRequestBooking> {
  HttpService http = HttpService();
  bool _isLoading = false;

  List<dynamic> requestBookingList = [];

  @override
  void initState() {
    _callGetData();
    // TODO: implement initState
    super.initState();
  }

  _callGetData() async {
    await _getRequestBooking();
  }

  _getRequestBooking() async {
    setState(() {
      _isLoading = true;
    });
    await http.post('booking/get-merchant-booking').then((res) {
      if (res["success"]) {
        setState(() {
          requestBookingList = res["data"];
        });
        print("================REQUESTBOOKING $requestBookingList");
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((err) {
      print("ERROR get-merchant-booking $err");
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingFallback(
        isLoading: _isLoading,
        child: ListView(
          children: [
            _buildAppbar(),
            const SizedBox(
              height: 30,
            ),
            _buildHeader(),
            const SizedBox(
              height: 16,
            ),
            (requestBookingList.isNotEmpty)
                ? _buildRequestBookingList()
                : EmptyFacilities(
                    message: "There are no booking request",
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestBookingList() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: requestBookingList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Map item = requestBookingList[index];
        return (item != null)
            ? Container(
                margin: EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: requestBookingCard(
                    facilityName: item["facility"]["name"],
                    facilityImage: item["facility"]["image"][0],
                    invoice: item["booking"]["invoice"],
                    date: (item["booking"]["bookingDate"].toString()) +
                        "/" +
                        (item["booking"]["bookingMonth"].toString()) +
                        "/" +
                        (item["booking"]["bookingYear"].toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailOwnerRequestBooking(
                            idBooking: item["booking"]["_id"],
                          ),
                        ),
                      );
                    }),
              )
            : Container();
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(
        right: 24,
        left: 24,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Request Booking",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Result Found (${requestBookingList.length})",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     const Text(
          //       "Sort By",
          //       style: TextStyle(
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 8,
          //     ),
          //     const Icon(
          //       Icons.filter_list_rounded,
          //     )
          //   ],
          // )
        ],
      ),
    );
  }

  Widget requestBookingCard({
    @required String facilityName,
    @required String facilityImage,
    @required String date,
    @required String invoice,
    @required Function onTap,
  }) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          // border: Border.all(width: 1, color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: facilityImage ??
                  "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
              imageBuilder: (context, imageProvider) => Container(
                width: 100.0,
                height: 100.0,
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
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   decoration: BoxDecoration(borderRadius: BorderRadius),
                  // ),
                  Text(
                    facilityName,
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Booked date : ",
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    "${date}",
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    "Invoice :",
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    "${invoice}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomArrowBack(
            onClick: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
