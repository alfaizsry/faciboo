import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/empty_facilities.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
import 'package:faciboo/components/request_booking_card.dart';
import 'package:faciboo/screens/detail_request_booking.dart';
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
                : const EmptyFacilities(
                    message: "There are no booking request",
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestBookingList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requestBookingList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Map item = requestBookingList[index];
        return (item != null)
            ? Container(
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: RequestBookingCard(
                    totalPrice: item["booking"]["total"],
                    status: item["booking"]["status"],
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
                          builder: (context) => DetailRequestBooking(
                            idBooking: item["booking"]["_id"],
                            isOwner: true,
                            onPop: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ).then((value) => _callGetData());
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
        ],
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
