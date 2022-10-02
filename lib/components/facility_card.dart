import 'package:flutter/material.dart';

class FacilityCard extends StatefulWidget {
  const FacilityCard({
    Key key,
    @required this.detailFacility,
    this.onClick,
  }) : super(key: key);

  final dynamic detailFacility;
  final Function onClick;

  @override
  State<FacilityCard> createState() => _FacilityCardState();
}

class _FacilityCardState extends State<FacilityCard> {
  List<String> bookStatusMsg = [
    "On Pay",
    "On Booking",
  ];
  List<Color> bookStatusColor = [
    Colors.yellow,
    Colors.green[200],
  ];
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(25),
      onTap: widget.onClick,
      child: Container(
        padding: EdgeInsets.all(20),
        width: 175,
        height: 175,
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
            image: NetworkImage(
              widget.detailFacility["image"],
            ),
            fit: BoxFit.cover,
          ),
          // border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buttonBookmark(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.detailFacility["is_booking"]) statusBooking(),
                Text(
                  widget.detailFacility["name"],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  widget.detailFacility["location"],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget statusBooking() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      margin: EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: bookStatusColor[
            widget.detailFacility["booking_detail"]["book_status"] - 1],
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Text(
        bookStatusMsg[
            widget.detailFacility["booking_detail"]["book_status"] - 1],
        style: TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  Widget buttonBookmark() {
    return Container(
      alignment: Alignment.topRight,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green[50],
            shape: BoxShape.circle,
          ),
          padding: EdgeInsets.all(4),
          child: widget.detailFacility["is_save"]
              ? Icon(
                  Icons.bookmark,
                  color: Colors.red,
                )
              : Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.green[900],
                ),
        ),
      ),
    );
  }
}
