import 'package:flutter/material.dart';

class CustomArrowBack extends StatefulWidget {
  const CustomArrowBack({
    Key key,
    @required this.onClick,
  }) : super(key: key);

  final Function onClick;
  @override
  State<CustomArrowBack> createState() => _CustomArrowBackState();
}

class _CustomArrowBackState extends State<CustomArrowBack> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: widget.onClick,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          // color: Colors.orange,
          shape: BoxShape.circle,
          border: Border.all(
            width: 0.7,
            color: Colors.grey,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          // size: 15,
        ),
      ),
    );
  }
}
