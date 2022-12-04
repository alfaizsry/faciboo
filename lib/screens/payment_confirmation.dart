import 'package:faciboo/components/custom_arrow_back.dart';
import 'package:faciboo/components/http_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen(this.data, {Key key}) : super(key: key);

  final dynamic data;
  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  HttpService http = HttpService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print(widget.data);
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
        Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              alignment: Alignment.center,
              child: const Text(
                "Payment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              alignment: Alignment.center,
              child: Text(
                "Booking ID ",
                style:
                    TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey[800]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildHeader(),
        ],
      ),
    );
  }
}
