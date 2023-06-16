import 'package:flutter/material.dart';
import 'package:irc_application/widgets/Label.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onPressed, this.text, this.width});
  final Function? onPressed;
  final Widget? text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        child: ElevatedButton(onPressed: () => onPressed?.call(), child: text));
  }
}
