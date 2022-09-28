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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // splashFactory: NoSplash.splashFactory,
      borderRadius: BorderRadius.circular(25),
      onTap: widget.onClick,
      child: Container(
        padding: EdgeInsets.only(
          top: 40,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        width: 150,
        height: 150,
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
      ),
    );
  }
}
