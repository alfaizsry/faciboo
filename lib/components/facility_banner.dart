import 'package:flutter/material.dart';

class FacilityBanner extends StatefulWidget {
  const FacilityBanner({
    Key key,
    @required this.detailFacility,
    this.onClick,
  }) : super(key: key);

  final dynamic detailFacility;
  final Function onClick;

  @override
  State<FacilityBanner> createState() => _FacilityBannerState();
}

class _FacilityBannerState extends State<FacilityBanner> {
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
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width - 48,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   colors: [
          //     Colors.blue,
          //     Colors.red,
          //   ],
          // ),
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
            image: NetworkImage(
              widget.detailFacility["image"] != null
                  ? widget.detailFacility["image"][0] ??
                      "https://images.unsplash.com/photo-1564352969906-8b7f46ba4b8b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"
                  : "https://images.unsplash.com/photo-1564352969906-8b7f46ba4b8b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
            ),
            fit: BoxFit.cover,
          ),
          // border: Border.all(width: 2, color: Colors.black),
          borderRadius: const BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.detailFacility["is_save"] != null) buttonBookmark(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.detailFacility["is_booking"] != null &&
                    widget.detailFacility["is_booking"])
                  statusBooking(),
                Text(
                  widget.detailFacility["name"] ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.detailFacility["address"] ?? "-",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
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
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: bookStatusColor[
            widget.detailFacility["booking_detail"]["book_status"] - 1],
        borderRadius: const BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Text(
        bookStatusMsg[
            widget.detailFacility["booking_detail"]["book_status"] - 1],
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  Widget rating() {
    return Container();
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
          padding: const EdgeInsets.all(4),
          child: widget.detailFacility["is_save"]
              ? const Icon(
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
