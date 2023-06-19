import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
          "CHECK STOCK",
          color: COLOR_WHITE,
          fontSize: 22,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: GridView.count(
                  shrinkWrap: true,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Image(
                                  image: AssetImage('assets/icons/csv2.png'),
                                  color: COLOR_WHITE,
                                  width: 160,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
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
                        color: COLOR_GRAY_BLUE,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Image(
                                  image: AssetImage('assets/icons/scanp.png'),
                                  color: COLOR_WHITE,
                                  width: 150,
                                ),
                              ),
                            ),
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
                        color: COLOR_GRAY_BLUE,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Label(
                "Date - Time : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}",
                color: COLOR_WHITE,
              ),
            ),
          ],
        ));
  }
}
