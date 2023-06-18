import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/route/route_generator.dart';
import 'package:irc_application/services/sqlite.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Label.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createDatabase();
  }

  void _createDatabase() async {
    await databaseHelper.initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
        isHidePreviour: true,
        textTitle: Label(
          "Count Stock IRC",
          color: COLOR_WHITE,
          fontSize: 22,
        ),
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
                        color: COLOR_GRAY_BLUE,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/icons/csv2.png'),
                              color: COLOR_WHITE,
                              width: 125,
                            ),
                            Label("Import")
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, RouterList.SCAN_SCREEN),
                      child: const Card(
                        color: COLOR_GRAY_BLUE,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image(
                                image: AssetImage('assets/icons/scanp.png'),
                                color: COLOR_WHITE,
                                width: 120,
                              ),
                            ),
                            Label("Scan")
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouterList.EXPORT_SCREEN),
                      child: const Card(
                        color: COLOR_GRAY_BLUE,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Image(
                                image: AssetImage('assets/icons/scanp.png'),
                                color: COLOR_WHITE,
                                width: 150,
                              ),
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
          ],
        ));
  }
}
