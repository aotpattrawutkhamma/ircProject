import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Label.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  List CsvModuleList = [];
  String csv = "";

  Future<void> _ExportCSV() async {
    var data = 'Date';
    data += 'Time';
    data += 'User';
    data += 'B1';
    data += 'B2';
    data += 'B3';
    data += 'B4';
    data += 'Location';

    var selectDirectory = '/storage/emulated/0/Dawnload';
    var filename = await getFilename('CSV');
    var pathFile = '$selectDirectory/$filename';

    var file = File(pathFile);
    var result = await file.writeAsString(data);
  }

  Future<String> getFilename(String extension) async {
    return '${DateTime.now().toIso8601String()}.extension';
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
      textTitle: const Label(
        "Export",
        fontSize: 20,
        color: COLOR_WHITE,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Center(
              child: CustomButton(
                width: 300,
                text: Label("Export Data"),
                onPressed: _ExportCSV,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
