import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      ///MainMenu
      // case RouterList.IMPORT_SCREEN:
      //   return PageTransition(
      //       settings: settings,
      //       child: MainMenuScreen(),
      //       type: PageTransitionType.fade);
    }
    throw UnsupportedError('Unknow route : ${settings.name}');
  }
}

class RouterList {
  static const String IMPORT_SCREEN = '/Import';
}
