import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';

class CustomInputField extends StatelessWidget {
  const CustomInputField(
      {super.key,
      this.labeltext,
      this.enabled,
      this.controller,
      this.fillColor = COLOR_TRANPARENT,
      this.onEditingComplete,
      this.focusNode,
      this.height,
      this.maxLines,
      this.colorText = COLOR_DARK_BLUE,
      this.onChanged,
      this.onFieldSubmitted});
  final Widget? labeltext;
  final bool? enabled;
  final TextEditingController? controller;
  final Color fillColor;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;
  final double? height;
  final int? maxLines;
  final Color colorText;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labeltext ?? Container(),
        Row(
          children: [
            Expanded(
              child: Container(
                height: height ?? 40,
                child: TextFormField(
                  onFieldSubmitted: onFieldSubmitted,
                  textInputAction: TextInputAction.go,
                  onChanged: onChanged,
                  maxLines: 1,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  controller: controller,
                  enabled: enabled,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(color: colorText),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      fillColor: fillColor,
                      focusedBorder: OutlineInputBorder(),
                      focusColor: Colors.transparent,
                      border: OutlineInputBorder()),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
