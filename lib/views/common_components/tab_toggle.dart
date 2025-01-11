
import 'package:flutter/material.dart';

class TabToggle extends StatefulWidget {
  const TabToggle({super.key, required this.onChange});
  final void Function(int) onChange;
  @override
  State<TabToggle> createState() => _TabToggleState();
}

class _TabToggleState extends State<TabToggle> {
  bool isPhone = true;
  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.black;
    const borderRadius = 8.0;
    const paddingVertical = 16.0;
    const paddingHorizontal = 16.0;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Row(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              setState(() {
                isPhone = true;
                //0 means Phone field
                widget.onChange(0);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: paddingVertical),
              decoration: BoxDecoration(
                  color: isPhone ? Theme.of(context).primaryColor : null,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius),
                      bottomLeft: Radius.circular(borderRadius))),
              child: Center(
                  child: Text(
                "Phone",
                style: TextStyle(color: isPhone ? Colors.white : null),
              )),
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              setState(() {
                isPhone = false;
                //1 means Email field
                widget.onChange(1);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal, vertical: paddingVertical),
              decoration: BoxDecoration(
                  color: !isPhone ? Theme.of(context).primaryColor : null,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(borderRadius),
                      bottomRight: Radius.circular(borderRadius))),
              child: Center(
                  child: Text("Email",
                      style: TextStyle(color: !isPhone ? Colors.white : null))),
            ),
          ))
        ],
      ),
    );
  }
}
