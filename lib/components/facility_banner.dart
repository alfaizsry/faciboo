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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(25),
      onTap: widget.onClick,
      child: Container(
        padding: EdgeInsets.only(
          top: 80,
          left: 20,
          right: 20,
          bottom: 20,
        ),
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.detailFacility["name"],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.detailFacility["location"],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            )
          ],
        ),
      ),
    );
  }
}
