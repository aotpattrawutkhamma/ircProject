import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:csv/csv.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/models/csvModel.dart';
import 'package:irc_application/models/csvScanModel.dart';
import 'package:irc_application/modelsSqlite/fileCsvModel.dart';
import 'package:irc_application/modelsSqlite/fileCsvScanModel.dart';
import 'package:irc_application/services/sqlite.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Label.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({Key? key}) : super(key: key);

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  List<CsvScanModel> csvModelData = [];
  List<CsvScanModel> _tempCsv = [];
  List<FileCsvScanModel> result = [];
  DatabaseHelper databaseHelper = DatabaseHelper();
  // final File file = File("/storage/emulated/0/Download/result.csv");
  final File file = File("/storage/101D-3E1F/Download/result2.csv");

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _deleted() async {
    if (result.isNotEmpty) {
      await databaseHelper.deleted('FileScanCsv');
      setState(() {
        result.clear();
        csvModelData.clear();
      });
      print("Test ${result.length}");
    } else if (csvModelData.isNotEmpty) {
      setState(() {
        csvModelData.clear();
      });
    }
  }

  Future<void> _ExportCSV() async {
    if (await Permission.storage.request().isGranted) {
      if (result.isNotEmpty) {
        var data = 'DATE';
        data += ',TIME';
        data += ',USER';
        data += ',B1';
        data += ',B2';
        data += ',B3';
        data += ',B4';
        data += ',LOCATION';
        data += '\r';

        var listData = result.length;
        if (result.isNotEmpty) {
          result.forEach((element) {
            data += '${element.DATE.toString()}';
            data += ',${element.TIME.toString()}';
            data += ',${element.USER.toString()}';
            data += ',${element.B1.toString()}';
            data += ',${element.B2.toString()}';
            data += ',${element.B3.toString()}';
            data += ',${element.B4.toString()}';
            data += ',${element.LOCATION.toString()}';
            data += '\r';
          });
        }

        var directory = await AndroidPathProvider.downloadsPath;

        var selectDirectory = '$directory';
        var directoryExists = await Directory(selectDirectory).exists();
        if (!directoryExists) {
          await Directory(selectDirectory).create(recursive: true);
        }

        ///storage/emulated/0/Download
        var filename = await getFilename('CSV');
        var pathFile = '$selectDirectory/$filename';

        var file = File(pathFile);
        await file.writeAsString(data);
        _deleted();
        _Dialog(
            text: Label("Save Complete" + '\n' + "File Name : " + '$filename'),
            isHideCancle: false,
            onpressOk: () async {
              await _deleted();
              Navigator.pop(context);
            });
      } else {
        _Dialog(
            text: Label("Data not Found"),
            isHideCancle: false,
            onpressOk: () async {
              await _deleted();
              Navigator.pop(context);
            });
      }
    } else {
      _Dialog(
          text: Label(
            "Exception",
            maxLines: 100,
          ),
          isHideCancle: false,
          onpressOk: () async {
            Navigator.pop(context);
          });
    }
  }

  // Future send(String TIME, String DATE, String USER, String B1, String B2,
  //     String B3, String B4, String LOCATION) async {
  //   try {
  //     await file.writeAsString(
  //         TIME += DATE += USER += B1 += B2 += B3 += B4 += LOCATION + '\n',
  //         mode: FileMode.write,
  //         flush: true);
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  //   return await file.length();
  // }

  Future _getData() async {
    List<Map<String, dynamic>> sqlData =
        await databaseHelper.queryData('FileScanCsv');
    if (sqlData.isNotEmpty) {
      setState(() {
        result = sqlData.map((e) => FileCsvScanModel.fromMap(e)).toList();
      });
    } else {
      print("Nodata");
    }
  }
  //BT-571-A+230328R002+448+20230428
  //TD-641-A+230327R002+832+20230411
  // Future _getData() async {
  //   List<Map<String, dynamic>> sqlData =
  //       await databaseHelper.queryData('FileScanCsv');
  //   if (sqlData.isNotEmpty) {
  //     setState(() {
  //       result = sqlData.map((e) => FileCsvScanModel.fromMap(e)).toList();
  //     });
  //   } else {
  //     print("Nodata");
  //   }
  // }

  Future<String> getFilename(String extension) async {
    return '${DateTime.now().toIso8601String().replaceAll('T', '').replaceAll('-', '').replaceAll(':', '').split('.')[0]}.$extension';
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
      textTitle: const Label(
        "EXPORT DATA",
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
                backgroundColor: COLOR_GREEN_LIGHT,
                width: 300,
                text: Label("Export Data", color: COLOR_WHITE),
                onPressed: _ExportCSV,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const DottedLine(
              dashColor: COLOR_WHITE,
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
                child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  color: COLOR_WHITE,
                  child: DataTable(
                      border: TableBorder.all(width: 1),
                      columnSpacing: 20,
                      horizontalMargin: 15,
                      columns: const [
                        DataColumn(label: Label('LOCATION')),
                        DataColumn(label: Center(child: Label('USER'))),
                        DataColumn(label: Center(child: Label('B1'))),
                        DataColumn(label: Center(child: Label('B2'))),
                        DataColumn(label: Center(child: Label('B3'))),
                        DataColumn(label: Center(child: Label('B4'))),
                        DataColumn(label: Center(child: Label('TIME'))),
                        DataColumn(label: Center(child: Label('DATE'))),
                      ],
                      rows: result.isNotEmpty
                          ? result.skip(0).map((e) {
                              return DataRow(cells: [
                                DataCell(Text(e.LOCATION ?? '')),
                                DataCell(Text(
                                  e.USER ?? '',
                                )),
                                DataCell(Text(
                                  e.B1 ?? '',
                                )),
                                DataCell(Text(
                                  e.B2 ?? '',
                                )),
                                DataCell(Text(
                                  e.B3 ?? '',
                                )),
                                DataCell(Text(
                                  e.B4 ?? '',
                                )),
                                DataCell(Text(
                                  e.TIME ?? '',
                                )),
                                DataCell(Text(
                                  e.DATE ?? '',
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

  void _Dialog(
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
