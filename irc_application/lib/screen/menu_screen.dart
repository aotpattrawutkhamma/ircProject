import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/route/route_generator.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Label.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBg(
        isHidePreviour: true,
        textTitle: Label("Menu"),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouterList.IMPORT_SCREEN),
                      child: const Card(
                        child: Column(
                          children: [
                            Expanded(
                                child: Image(
                              image: AssetImage('assets/icons/csv2.png'),
                              width: 150,
                            )),
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Label("Import"),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, RouterList.SCAN_SCREEN),
                      child: const Card(
                        child: Column(
                          children: [
                            Expanded(
                                child: Image(
                              image: AssetImage('assets/icons/scanp.png'),
                              width: 150,
                            )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Label("Scan"),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouterList.EXPROT_SCREEN),
                      child: const Card(
                        child: Column(
                          children: [
                            Expanded(
                                child: Image(
                              image: AssetImage('assets/icons/scanp.png'),
                              width: 150,
                            )),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Label("Export"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            Expanded(
              child: Label(
                "Please enter  number 1 - 3 to select the menu",
                color: COLOR_DANGER,
              ),
            )
          ],
        ));
  }
}
