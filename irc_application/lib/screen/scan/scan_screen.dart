import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Custom_inputfield.dart';
import 'package:irc_application/widgets/Label.dart';

import '../../modelsSqlite/fileCsvModel.dart';
import '../../services/sqlite.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _b1Controller = TextEditingController();
  final TextEditingController _b2Controller = TextEditingController();
  final TextEditingController _b3Controller = TextEditingController();
  final TextEditingController _b4Controller = TextEditingController();

  // List<String> itemList1 = ['String', "Test"];
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<FileCsvModel> itemList = [];
  List<String> _location = [];
  final FocusNode _f1 = FocusNode();
  final FocusNode _f2 = FocusNode();
  final FocusNode _f3 = FocusNode();
  final FocusNode _enter = FocusNode();

  Future _getData() async {
    var sql = await databaseHelper.queryData('FileCsv');
    if (sql.isNotEmpty) {
      setState(() {
        itemList = sql.map((e) => FileCsvModel.fromMap(e)).toList();
        _location = itemList.map((e) => e.LOCATION!).toSet().toList();
      });
    } else {
      print("Nodata");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _f1.requestFocus();
    _getData();
  }

  Future _checkDataWithLocation() async {
    try {
      var sql = await databaseHelper.queryData('FileCsv');

      bool isFound = false;
      for (var items in sql) {
        if (_locationController.text == items['LOCATION'] &&
            _barcodeController.text.trim() == items['DATA']) {
          isFound = true;
          break;
        } else {
          isFound = false;
        }
      }
      if (isFound == true) {
        setState(() {
          _b1Controller.text = _barcodeController.text.substring(0, 8);
          _b2Controller.text = _barcodeController.text.substring(9, 19);
          _b3Controller.text = _barcodeController.text.split('+')[2];
          _b4Controller.text = _barcodeController.text.split('+').last;
          if (_b4Controller.text.trim() == _b3Controller.text.trim()) {
            _b4Controller.clear();
          }
        });
      } else {
        _errorDialog(
            isHideCancle: false,
            text: Label("Product Location Invaild"),
            onpressOk: () {
              _b1Controller.clear();
              _b2Controller.clear();
              _b3Controller.clear();
              _b4Controller.clear();
              Navigator.pop(context);
            });
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
  }

  Future _saveData() async {
    await databaseHelper.insertSqlite('tableName', {
      '': _userController.text.trim(),
      '': _locationController.text.trim(),
      '': _barcodeController.text.trim(),
      '': _b1Controller.text.trim(),
      '': _b2Controller.text.trim(),
      '': _b3Controller.text.trim(),
      '': _b4Controller.text.trim()
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
        textTitle: Label(
          "Scan",
          fontSize: 24,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomInputField(
                  focusNode: _f1,
                  controller: _userController,
                  labeltext: Label("User :"),
                  onEditingComplete: () {
                    _f2.requestFocus();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(child: Label("Location")),
                    Expanded(flex: 4, child: _dropdownButton())
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                CustomInputField(
                  focusNode: _f3,
                  controller: _barcodeController,
                  labeltext: Label("Barcode"),
                  onEditingComplete: () {
                    _checkDataWithLocation();
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                CustomInputField(
                  controller: _b1Controller,
                  labeltext: Label("B1"),
                  enabled: false,
                  fillColor: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomInputField(
                  controller: _b2Controller,
                  labeltext: Label("B2"),
                  enabled: false,
                  fillColor: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomInputField(
                  controller: _b3Controller,
                  labeltext: Label("B3"),
                  enabled: false,
                  fillColor: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomInputField(
                  controller: _b4Controller,
                  labeltext: Label("B4"),
                  enabled: false,
                  fillColor: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(
                  height: 15,
                ),
                CustomButton(
                  text: Label("Save"),
                )
              ],
            ),
          ),
        ));
  }

  Widget _dropdownButton() {
    return DropdownButtonFormField2<String>(
      focusNode: _f2,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      isExpanded: true,
      hint: Center(
        child: Text(
          'Please Select',
          style: TextStyle(fontSize: 14),
        ),
      ),
      items: _location
          .skip(1)
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Label(item),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _locationController.text = value!;
          _f3.requestFocus();
        });
      },
      buttonStyleData: const ButtonStyleData(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 20,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
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
