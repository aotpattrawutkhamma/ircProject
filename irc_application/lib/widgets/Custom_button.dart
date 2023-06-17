import 'package:flutter/material.dart';
import 'package:irc_application/widgets/Label.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, this.onPressed, this.text, this.width, this.backgroundColor});
  final Function? onPressed;
  final Widget? text;
  final double? width;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width ?? MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () => onPressed?.call(),
          child: text,
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(backgroundColor)),
        ));
  }
}
