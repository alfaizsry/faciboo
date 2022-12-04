import 'package:flutter/material.dart';

class EmptyFacilities extends StatefulWidget {
  const EmptyFacilities({
    Key key,
    this.message = "There are no facilities",
  }) : super(key: key);

  final String message;

  @override
  State<EmptyFacilities> createState() => _EmptyFacilitiesState();
}

class _EmptyFacilitiesState extends State<EmptyFacilities> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 175,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_rounded,
              color: Colors.grey.shade400,
              size: 50,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
