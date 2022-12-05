import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RequestBookingCard extends StatefulWidget {
  const RequestBookingCard({
    Key key,
    @required this.facilityName,
    @required this.facilityImage,
    @required this.date,
    @required this.invoice,
    @required this.onTap,
    @required this.status,
    @required this.totalPrice,
  }) : super(key: key);
  final int status;
  final int totalPrice;
  final String facilityName;
  final String facilityImage;
  final String date;
  final String invoice;
  final Function onTap;
  @override
  State<RequestBookingCard> createState() => _RequestBookingCardState();
}

class _RequestBookingCardState extends State<RequestBookingCard> {
  List<Map> status = [
    {
      "status": "Waiting Payment",
      "color": Colors.orange,
    },
    {
      "status": "On Booking",
      "color": Colors.green,
    },
    {
      "status": "Done",
      "color": Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          // border: Border.all(width: 1, color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Column(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.facilityImage ??
                      "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=740&t=st=1669888811~exp=1669889411~hmac=ab35157190db779880c061298b0fa239e5bc753da4191dd09b0df84726227f4a",
                  imageBuilder: (context, imageProvider) => Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                      child: const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                _buildStatusCard(),
              ],
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: _buildStatusCard(),
                  // ),
                  // const SizedBox(
                  //   height: 8,
                  // ),
                  Text(
                    widget.facilityName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Booked date : ",
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    widget.date,
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
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    widget.invoice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    "Total :",
                    style: TextStyle(
                      // color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    "Rp${widget.totalPrice}",
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
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.green.shade900,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status[widget.status]["color"],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status[widget.status]["status"],
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
      ),
    );
  }
}
