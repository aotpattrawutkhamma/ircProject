import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/models/csvModel.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Label.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  List<List<dynamic>> csvData = [];

  Future<void> _importCSV() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final String csvPath = result.files.single.path!;
      final String csvString =
          await File(csvPath).readAsString(encoding: latin1);
      setState(() {
        csvData = CsvToListConverter().convert(csvString);
      });

      // ทำอะไรกับข้อมูล CSV ที่ได้ที่นี่
      print(csvData);
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
              CustomButton(
                width: 150,
                text: Label("Clear"),
              ),
              const SizedBox(
                height: 20,
              ),
              const DottedLine(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Label(csvData[index].toString()),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
