import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/models/csvModel.dart';
import 'package:irc_application/modelsSqlite/fileCsvModel.dart';
import 'package:irc_application/services/sqlite.dart';
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
  List<CsvModel> csvModelData = [];
  String csv = "";
  List<FileCsvModel> result = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _getData();
  }

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

  Future _getData() async {
    List<Map<String, dynamic>> sqlData =
        await databaseHelper.queryData('FileCsv');
    if (sqlData.isNotEmpty) {
      setState(() {
        result = sqlData.map((e) => FileCsvModel.fromMap(e)).toList();
      });
    } else {
      print("Nodata");
    }
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
            const SizedBox(
              height: 30,
            ),
            Center(
              child: CustomButton(
                width: 300,
                text: Label("Export Data"),
                onPressed: _ExportCSV,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const DottedLine(
              dashColor: COLOR_WHITE,
            ),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: COLOR_WHITE,
                  child: DataTable(
                      border: TableBorder.all(width: 1),
                      columnSpacing: 20,
                      horizontalMargin: 15,
                      columns: [
                        DataColumn(label: Label('DATE')),
                        DataColumn(label: Label('TIME')),
                        DataColumn(label: Label('B1')),
                        DataColumn(label: Label('B2')),
                        DataColumn(label: Label('B3')),
                        DataColumn(label: Label('B4')),
                        DataColumn(label: Label('LOCATION')),
                      ],
                      rows: csvModelData.isNotEmpty
                          ? csvModelData.skip(1).map((data) {
                              return DataRow(cells: [
                                DataCell(Label(data.LOCATION ?? '')),
                                DataCell(Label(
                                  data.DATA ?? '',
                                  fontSize: 15,
                                )),
                              ]);
                            }).toList()
                          : result.isNotEmpty
                              ? result.skip(1).map((e) {
                                  return DataRow(cells: [
                                    DataCell(Text(e.LOCATION ?? '')),
                                    DataCell(Text(
                                      e.DATA ?? '',
                                    )),
                                  ]);
                                }).toList()
                              : List.empty()),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
