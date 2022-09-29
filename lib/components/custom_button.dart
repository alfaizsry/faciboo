import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key key,
    @required this.textButton,
    @required this.onClick,
    this.prefixIcon,
    this.colorButton = Colors.green,
    this.colorTextButton = Colors.white,
    this.textButtonSize = 14,
  }) : super(key: key);

  final String textButton;
  final double textButtonSize;
  final Widget prefixIcon;
  final Color colorButton;
  final Color colorTextButton;
  final Function onClick;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onClick,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.colorButton,
          borderRadius: BorderRadius.all(
            Radius.circular(
              36,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.prefixIcon != null) widget.prefixIcon,
            Text(
              widget.textButton,
              style: TextStyle(
                fontSize: widget.textButtonSize,
                color: widget.colorTextButton,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
