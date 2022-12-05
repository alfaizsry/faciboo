import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/custom_button.dart';
import 'package:faciboo/components/helper.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:faciboo/screens/detail_request_booking.dart';
import 'package:faciboo/screens/payment_confirmation.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen(this.data, {Key key}) : super(key: key);

  final dynamic data;
  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  HttpService http = HttpService();

  String basePrice = '';
  String totalPrice = '';
  String showDateTime = '';

  bool isLoading = false;

  String priceParser(dynamic initial) {
    String result =
        NumberFormat().format(initial).toString().replaceAll(',', '.');
    return 'Rp. $result';
  }

  String dateTimeToString(DateTime initial) {
    String formatted = DateFormat('d MMMM yyyy').format(initial);
    return formatted;
  }

  void confirmBooking() {
    Map body = {
      "bookingDate": widget.data['date'],
      "bookingMonth": widget.data['month'],
      "bookingYear": widget.data['year'],
      "bookingHour": widget.data['hour'],
      "total": widget.data['base_price'] * widget.data['hour'].length,
      "facilityId": widget.data['id']
    };
    print("BODY REQUEST CONFIRMATION BOOKING ====> $body");
    http.post('booking/booking', body: body).then((res) {
      print(res);
      if (res['success']) {
        Map data = {
          'showDate': showDateTime,
          'showPrice': totalPrice,
        };
        data.addAll(res['data']);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DetailRequestBooking(
            isFromConfirmPage: true,
            idBooking: data["_id"],
            onPop: () {
              Alert(
                style: const AlertStyle(
                  isCloseButton: false,
                ),
                context: context,
                //type: AlertType.,
                title: "Waiting for Payment!",
                content: Column(
                  children: const [
                    Text(
                      "Are you sure you want to exit the payment page? You can continue payment through the booking page",
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Pay Later",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pushReplacementNamed("/home");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    color: Colors.green,
                  ),
                  DialogButton(
                    child: const Text(
                      "Return",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.red),
                  ),
                ],
              ).show();
            },
          ),
        ));

        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.green[600],
          message: res["msg"],
          duration: const Duration(seconds: 3),
        ).show(context);
      } else {
        Flushbar(
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.red,
          message: res["msg"],
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }).catchError((onError) {});
  }

  @override
  void initState() {
    super.initState();
    basePrice = priceParser(widget.data['base_price']);
    totalPrice =
        priceParser(widget.data['base_price'] * widget.data['hour'].length);
    showDateTime = dateTimeToString(widget.data['date_time']);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: CustomArrowBack(
            onClick: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          alignment: Alignment.center,
          child: const Text(
            "Confirmation",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyDetailsConfirmation() {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.only(top: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: const Text(
              'Your Book',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  showDateTime,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hours',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: width * 0.3,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.data['hour'].length,
                      itemBuilder: (BuildContext context, int i) {
                        return SizedBox(
                          width: double.infinity,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 4, top: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.green[600]),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                widget.data['hour'][i],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'x${widget.data['hour'].length}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  basePrice,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Container(
            width: width,
            height: 0.5,
            color: Colors.black,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Price',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
                Text(
                  totalPrice,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          _buildHeader(),
          _buildBodyDetailsConfirmation(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: CustomButton(
              textButton: "Confirm & Continue Payment",
              onClick: () {
                confirmBooking();
              },
              colorButton: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
