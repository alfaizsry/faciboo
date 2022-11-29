import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key key,
    @required this.textButton,
    @required this.onClick,
    this.prefixIcon,
    this.colorButton,
    this.colorTextButton = Colors.white,
    this.textButtonSize = 14,
    this.padding,
  }) : super(key: key);

  final String textButton;
  final double textButtonSize;
  final Widget prefixIcon;
  final Color colorButton;
  final Color colorTextButton;
  final Function onClick;
  final EdgeInsets padding;

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
        padding: (widget.padding != null)
            ? widget.padding
            : const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
        alignment: Alignment.center,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: widget.colorButton ?? const Color(0xFF24AB70),
          borderRadius: const BorderRadius.all(
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
