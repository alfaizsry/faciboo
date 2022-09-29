import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  const CustomTabBar({
    Key key,
    this.category,
    this.onClick,
  }) : super(key: key);

  final List<dynamic> category;
  final Function onClick;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.category.length; i++)
          InkWell(
            splashFactory: NoSplash.splashFactory,
            onTap: widget.onClick,
            child: Row(
              children: [
                Text(
                  widget.category[i]["category"],
                  style: TextStyle(
                    // fontWeight:
                    // (selectedCategory == i)
                    //     ? FontWeight.w700
                    //     : FontWeight.normal,
                    fontSize: 18,
                    // color: (selectedCategory == i) ? Colors.black : Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
              ],
            ),
          )
      ],
    );
  }
}
