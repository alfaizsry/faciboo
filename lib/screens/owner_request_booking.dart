import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/components/loading_fallback.dart';
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
          ],
        ),
      ),
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
