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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
