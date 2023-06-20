import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/models/csvModel.dart';
import 'package:irc_application/modelsSqlite/fileCsvModel.dart';
import 'package:irc_application/services/sqlite.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Label.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  List<CsvModel> csvModelData = [];
  List<FileCsvModel> result = [];
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<void> _importCSV() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final String csvPath = result.files.single.path!;
      final String csvString =
          await File(csvPath).readAsString(encoding: latin1);

      final List<List<dynamic>> csvData =
          CsvToListConverter().convert(csvString);

      final List<CsvModel> convertedData = csvData.map((row) {
        return CsvModel(
          LOCATION: row[0],
          DATA: row[1],
        );
      }).toList();

      setState(() {
        csvModelData = convertedData;
      });
    }
  }

  Future<void> _saveData() async {
    if (csvModelData.isNotEmpty) {
      var sql = await databaseHelper.queryData('FileCsv');
      if (sql.isEmpty) {
        csvModelData.forEach((element) async {
          await databaseHelper.insertSqlite(
              'FileCsv', {'LOCATION': element.LOCATION, 'DATA': element.DATA});
        });
        csvModelData.clear();
        await _getData();
      } else if (sql.isNotEmpty) {
        await databaseHelper.deleted('FileCsv');
        csvModelData.forEach((element) async {
          await databaseHelper.insertSqlite(
              'FileCsv', {'LOCATION': element.LOCATION, 'DATA': element.DATA});
        });
        csvModelData.clear();
        await _getData();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    List<Map<String, dynamic>> sqlData =
        await databaseHelper.queryData('FileCsv');
    if (sqlData.isNotEmpty) {
      setState(() {
        result = sqlData.map((e) => FileCsvModel.fromMap(e)).toList();
      });
    } else {}
  }

  Future _deleted() async {
    if (result.isNotEmpty) {
      await databaseHelper.deleted('FileCsv');

      setState(() {
        result.clear();
        csvModelData.clear();
      });
    } else if (csvModelData.isNotEmpty) {
      setState(() {
        csvModelData.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
        textTitle: const Label(
          "IMPORT DATA",
          fontSize: 20,
          color: COLOR_WHITE,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomButton(
                      backgroundColor:
                          csvModelData.isNotEmpty ? COLOR_ACTIVE : Colors.grey,
                      text: Label(
                        "Save",
                        color: COLOR_WHITE,
                      ),
                      onPressed: () async {
                        if (csvModelData.isNotEmpty) {
                          Alert(
                              context: context,
                              type: AlertType.warning,
                              closeIcon: Label(""),
                              desc:
                                  "Do you want to save  ? \nRecord : ${csvModelData.skip(1).length}",
                              style: AlertStyle(
                                  descPadding: EdgeInsets.only(top: 5),
                                  descStyle: TextStyle(fontSize: 16)),
                              buttons: [
                                DialogButton(
                                    color: COLOR_DANGER,
                                    child: Label(
                                      "Cancel",
                                      color: COLOR_WHITE,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    }),
                                DialogButton(
                                    color: COLOR_ACTIVE,
                                    child: Label("OK", color: COLOR_WHITE),
                                    onPressed: () async {
                                      _saveData();
                                      Navigator.pop(context);
                                      EasyLoading.showSuccess("Save Success",
                                          duration: Duration(seconds: 3));
                                    })
                              ]).show();
                        } else {
                          Alert(
                              context: context,
                              type: AlertType.warning,
                              closeIcon: Label(""),
                              desc: "Please Import CSV",
                              style: AlertStyle(
                                  descPadding: EdgeInsets.only(top: 5),
                                  descStyle: TextStyle(fontSize: 16)),
                              buttons: [
                                DialogButton(
                                    color: COLOR_ACTIVE,
                                    child: Label("OK", color: COLOR_WHITE),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    })
                              ]).show();
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      backgroundColor: COLOR_GREEN_LIGHT,
                      text: Label(
                        "Import",
                        color: COLOR_WHITE,
                      ),
                      onPressed: _importCSV,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomButton(
                      backgroundColor:
                          result.isNotEmpty ? COLOR_DANGER : Colors.grey,
                      text: Label(
                        "Clear",
                        color: COLOR_WHITE,
                      ),
                      onPressed: () async {
                        if (result.isNotEmpty) {
                          Alert(
                              context: context,
                              type: AlertType.warning,
                              closeIcon: Label(""),
                              desc: "Do you want to Delete ?",
                              style: AlertStyle(
                                  descPadding: EdgeInsets.only(top: 5),
                                  descStyle: TextStyle(fontSize: 16)),
                              buttons: [
                                DialogButton(
                                    color: COLOR_DANGER,
                                    child: Label(
                                      "Cancel",
                                      color: COLOR_WHITE,
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    }),
                                DialogButton(
                                    color: COLOR_ACTIVE,
                                    child: Label("OK", color: COLOR_WHITE),
                                    onPressed: () async {
                                      await _deleted();
                                      Navigator.pop(context);
                                      EasyLoading.showSuccess("Delete Success",
                                          duration: Duration(seconds: 3));
                                    })
                              ]).show();
                        } else {
                          Alert(
                              context: context,
                              type: AlertType.warning,
                              closeIcon: Label(""),
                              desc: "Please Save Data",
                              style: AlertStyle(
                                  descPadding: EdgeInsets.only(top: 5),
                                  descStyle: TextStyle(fontSize: 16)),
                              buttons: [
                                DialogButton(
                                    color: COLOR_ACTIVE,
                                    child: Label("OK", color: COLOR_WHITE),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    })
                              ]).show();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const DottedLine(
                dashColor: COLOR_WHITE,
              ),
              const SizedBox(
                height: 10,
              ),
              csvModelData.isNotEmpty
                  ? Label(
                      "Record: ${(csvModelData.skip(1).length)} row",
                      color: COLOR_WHITE,
                      fontSize: 20,
                    )
                  : Label(
                      "Record: ${(result.skip(1).length)} row",
                      color: COLOR_WHITE,
                      fontSize: 20,
                    ),
              const SizedBox(
                height: 10,
              ),
              const DottedLine(
                dashColor: COLOR_WHITE,
              ),
              const SizedBox(
                height: 10,
              ),
              // Expanded(
              //     child: ListView.builder(
              //         itemCount: csvModelData.length,
              //         itemBuilder: (context, index) {
              //           return Container(
              //             margin: EdgeInsets.all(5),
              //             padding: EdgeInsets.all(8),
              //             decoration: BoxDecoration(
              //                 color: COLOR_WHITE,
              //                 borderRadius: BorderRadius.circular(12),
              //                 border: Border.all()),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 // ข้ามรายการแรก
              //                 Label(
              //                     "Location : ${csvModelData[index].LOCATION.toString()}"),
              //                 Label(
              //                   "Data ${csvModelData[index].DATA.toString()}",
              //                   maxLines: 1,
              //                 )
              //                 // Label(csvModelData[index].LOCATION.toString())
              //               ],
              //             ),
              //           );
              //         }))

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
                          DataColumn(label: Label('LOCATION')),
                          DataColumn(label: Center(child: Label('DATA'))),
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
                                ? result.skip(1).map((data) {
                                    return DataRow(cells: [
                                      DataCell(Label(data.LOCATION ?? '')),
                                      DataCell(Label(
                                        data.DATA ?? '',
                                        fontSize: 15,
                                      )),
                                    ]);
                                  }).toList()
                                : List.empty()),
                  ),
                ),
              ))
            ],
          ),
        ));
  }

  void _errorDialog(
      {Label? text,
      Function? onpressOk,
      Function? onpressCancel,
      bool isHideCancle = true}) async {
    // EasyLoading.showError("Error[03]", duration: Duration(seconds: 5));//if password
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: text,
            ),
          ],
        ),

        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: isHideCancle,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(COLOR_DANGER)),
                  onPressed: () => Navigator.pop(context),
                  child: const Label(
                    'Cancel',
                    color: COLOR_WHITE,
                  ),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(COLOR_ACTIVE)),
                  onPressed: () => onpressOk?.call(),
                  child: const Label(
                    'OK',
                    color: COLOR_WHITE,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
