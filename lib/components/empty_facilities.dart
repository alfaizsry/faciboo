import 'package:flutter/material.dart';

class EmptyFacilities extends StatefulWidget {
  const EmptyFacilities({Key key}) : super(key: key);

  @override
  State<EmptyFacilities> createState() => _EmptyFacilitiesState();
}

class _EmptyFacilitiesState extends State<EmptyFacilities> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
            SizedBox(
              height: 8,
            ),
            Text(
              "There are no facilities",
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
