import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';

class Label extends StatelessWidget {
  const Label(this.text,
      {super.key,
      this.color = COLOR_BLACK,
      this.fontSize = 16,
      this.fontWeight});
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }
}
