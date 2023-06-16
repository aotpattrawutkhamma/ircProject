import 'package:flutter/material.dart';

import '../config/app_constants.dart';

class CustomBg extends StatelessWidget {
  const CustomBg(
      {this.isHideAppBar = false,
      this.isHideTitle = false,
      required this.body,
      this.appbar,
      this.isHidePreviour = false,
      this.textTitle,
      this.bottomNavigationBar,
      this.onPressedBack,
      super.key});
  final Widget? body;
  final Widget? appbar;
  final bool isHideAppBar;
  final bool isHideTitle;
  final Widget? textTitle;
  final bool isHidePreviour;
  final Widget? bottomNavigationBar;
  final Function? onPressedBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: isHideAppBar
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: Colors.grey,
              centerTitle: true,
              title: isHideTitle ? null : textTitle,
              automaticallyImplyLeading: false,
              leading: isHidePreviour
                  ? null
                  : BackButton(
                      color: COLOR_BLACK,
                      onPressed: () =>
                          onPressedBack?.call() ?? Navigator.pop(context),
                    ),
            ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
