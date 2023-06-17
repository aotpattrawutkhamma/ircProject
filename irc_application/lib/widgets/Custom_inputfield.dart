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
      this.maxLines});
  final Widget? labeltext;
  final bool? enabled;
  final TextEditingController? controller;
  final Color fillColor;
  final Function? onEditingComplete;
  final FocusNode? focusNode;
  final double? height;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        labeltext ?? Container(),
        Expanded(
          flex: 4,
          child: Container(
            height: height ?? 40,
            child: TextFormField(
              maxLines: 1,
              focusNode: focusNode,
              onEditingComplete: () => onEditingComplete?.call(),
              controller: controller,
              enabled: enabled,
              textAlignVertical: TextAlignVertical.center,
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
    );
  }
}
