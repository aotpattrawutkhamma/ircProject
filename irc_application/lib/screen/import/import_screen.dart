import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/models/csvModel.dart';
import 'package:irc_application/modelsSqlite/fileCsvModel.dart';
import 'package:irc_application/services/sqlite.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Label.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  List<CsvModel> csvModelData = [];
  List<CsvModel> _tempCsv = [];
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

  Future _saveData() async {
    if (csvModelData.isNotEmpty) {
      var sql = await databaseHelper.queryData('FileCsv');
      if (sql.isEmpty) {
        csvModelData.forEach((element) async {
          await databaseHelper.insertSqlite(
              'FileCsv', {'LOCATION': element.LOCATION, 'DATA': element.DATA});
        });
      } else {
        _errorDialog(
            text: Label("Do you want to save again ?"),
            onpressOk: () async {
              await databaseHelper.deleted('FileCsv');
              csvModelData.forEach((element) async {
                await databaseHelper.insertSqlite('FileCsv',
                    {'LOCATION': element.LOCATION, 'DATA': element.DATA});
              });
              Navigator.pop(context);
            });
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
    } else {
      print("Nodata");
    }
  }

  Future _deleted() async {
    if (result.isNotEmpty) {
      await databaseHelper.deleted('FileCsv');

      setState(() {
        result.clear();
      });
      print("Test ${result.length}");
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
          "Import",
          fontSize: 20,
          color: COLOR_WHITE,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomButton(
                  width: 300,
                  text: Label("Import"),
                  onPressed: _importCSV,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    width: 150,
                    text: Label("Save"),
                    onPressed: () async {
                      _errorDialog(
                          text: Label("Do you want to save  ?"),
                          onpressOk: () async {
                            await _saveData();
                            Navigator.pop(context);
                          });
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CustomButton(
                    width: 150,
                    text: Label("Clear"),
                    onPressed: () async {
                      _deleted();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const DottedLine(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey,
                  child: DataTable(
                      columns: [
                        DataColumn(label: Text('LOCATION')),
                        DataColumn(label: Text('DATA')),
                      ],
                      rows: csvModelData.isNotEmpty
                          ? csvModelData.skip(1).map((data) {
                              return DataRow(cells: [
                                DataCell(Text(data.LOCATION ?? '')),
                                DataCell(Text(data.DATA ?? '')),
                              ]);
                            }).toList()
                          : result.isNotEmpty
                              ? result.skip(1).map((e) {
                                  return DataRow(cells: [
                                    DataCell(Text(e.LOCATION ?? '')),
                                    DataCell(Text(e.DATA ?? '')),
                                  ]);
                                }).toList()
                              : List.empty()),
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
                      backgroundColor: MaterialStatePropertyAll(COLOR_AMBER)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              Visibility(
                visible: isHideCancle,
                child: SizedBox(
                  width: 15,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(COLOR_AMBER)),
                onPressed: () => onpressOk?.call(),
                child: const Text('OK'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
