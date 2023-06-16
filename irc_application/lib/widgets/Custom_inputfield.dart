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
      this.focusNode});
  final Widget? labeltext;
  final bool? enabled;
  final TextEditingController? controller;
  final Color fillColor;
  final Function? onEditingComplete;
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: labeltext ?? Container()),
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 40,
            child: TextFormField(
              focusNode: focusNode,
              onEditingComplete: () => onEditingComplete?.call(),
              controller: controller,
              enabled: enabled,
              textAlignVertical: TextAlignVertical.top,
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
