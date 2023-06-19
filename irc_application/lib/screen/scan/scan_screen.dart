import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
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
  List<Map<String, dynamic>> _scanned = [];
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

  Future _getDataFileScaned() async {
    var sql = await databaseHelper.queryData('FileScanCsv');
    if (sql.isNotEmpty) {
      setState(() {
        _scanned = sql;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _f1.requestFocus();
    _getData();
    _getDataFileScaned();
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
      //BT-571-A+230328R002+448+20230428
      if (isFound == true) {
        setState(() {
          _b1Controller.text = _barcodeController.text.substring(0, 8);
          _b2Controller.text = _barcodeController.text.substring(9, 19);
          _b3Controller.text = _barcodeController.text.split('+')[2];
          _b4Controller.text = _barcodeController.text.split('+').last;
          if (_b4Controller.text.trim() == _b3Controller.text.trim()) {
            _b4Controller.clear();
          }
          _saveData();
        });
      } else {
        _errorDialog(
            isHideCancle: false,
            text: Label("Product Location Invaild"),
            onpressOk: () {
              _barcodeController.clear();
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
    var sql = await databaseHelper.queryData('FileScanCsv');
    bool isFound = false;
    for (var items in sql) {
      if (_barcodeController.text == items['BARCODE'] &&
          _locationController.text == items['LOCATION']) {
        isFound = true;
        break;
      } else {
        isFound = false;
      }
    }
    if (isFound == true) {
      _errorDialog(
          isHideCancle: false,
          text: Label("Location ${_locationController.text} duplicate"),
          onpressOk: () {
            setState(() {
              _barcodeController.clear();
              _b1Controller.text = '';
              _b2Controller.text = '';
              _b3Controller.text = '';
              _b4Controller.text = '';
            });

            Navigator.pop(context);
          });
    } else if (isFound == false) {
      await databaseHelper.insertSqlite('FileScanCsv', {
        'LOCATION': _locationController.text.trim(),
        'USER': _userController.text.trim(),
        'BARCODE': _barcodeController.text.trim(),
        'B1': _b1Controller.text.trim(),
        'B2': _b2Controller.text.trim(),
        'B3': _b3Controller.text.trim(),
        'B4': _b4Controller.text,
        'TIME': DateFormat('HH:mm:ss').format(DateTime.now()),
        'DATE': DateFormat('yyyy-MM-dd ').format(DateTime.now()),
      });
      EasyLoading.showSuccess("Save Complete", duration: Duration(seconds: 3));
      _barcodeController.clear();
      _getDataFileScaned();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
        textTitle: Label(
          "SCAN CHECK",
          fontSize: 24,
          color: COLOR_WHITE,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInputField(
                  focusNode: _f1,
                  controller: _userController,
                  labeltext: Label(
                    "User : ",
                    color: COLOR_WHITE,
                  ),
                  onEditingComplete: () {
                    _f2.requestFocus();
                  },
                  fillColor: COLOR_WHITE,
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      "Location:",
                      color: COLOR_WHITE,
                    ),
                    Row(
                      children: [Expanded(flex: 4, child: _dropdownButton())],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomInputField(
                  focusNode: _f3,
                  controller: _barcodeController,
                  maxLines: 2,
                  labeltext: Label(
                    "Barcode : ",
                    color: COLOR_WHITE,
                  ),
                  onEditingComplete: () {
                    if (_barcodeController.text.isNotEmpty &&
                        _locationController.text.isNotEmpty &&
                        _userController.text.isNotEmpty) {
                      _checkDataWithLocation();
                    } else {
                      _errorDialog(
                          isHideCancle: false,
                          text: _userController.text.isEmpty
                              ? Label("Please Input User")
                              : _locationController.text.isEmpty
                                  ? Label("Please Select Location")
                                  : _barcodeController.text.isEmpty
                                      ? Label("Please Input User")
                                      : null,
                          onpressOk: () {
                            if (_userController.text.isEmpty) {
                              _f1.requestFocus();
                            } else if (_locationController.text.isEmpty) {
                              _f2.requestFocus();
                            } else
                              (_f3.requestFocus());
                            Navigator.pop(context);
                          });
                    }
                  },
                  fillColor: COLOR_WHITE,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        _b1Controller.text = '';
                        _b2Controller.text = '';
                        _b3Controller.text = '';
                        _b4Controller.text = '';
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Label(
                        "B1 : ${_b1Controller.text} ",
                        color: COLOR_WHITE,
                      ),
                    ),
                    Expanded(
                      child: Label(
                        "B2 : ${_b2Controller.text}",
                        color: COLOR_WHITE,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Label(
                        "B3 : ${_b3Controller.text} ",
                        color: COLOR_WHITE,
                      ),
                    ),
                    Expanded(
                      child: Label(
                        "B4 : ${_b4Controller.text} ",
                        color: COLOR_WHITE,
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: COLOR_WHITE,
                  thickness: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Label(
                  "Record Count : ${_scanned.length}",
                  color: COLOR_WHITE,
                ),
                Label(
                  "Date - Time ${DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now())}",
                  color: COLOR_WHITE,
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
        filled: true,
        fillColor: COLOR_WHITE,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      isExpanded: true,
      hint: Center(
        child: itemList.isNotEmpty
            ? Text(
                'Please Select Location',
                style: TextStyle(fontSize: 14),
              )
            : Text(
                'Please Import Data',
                style: TextStyle(fontSize: 14),
              ),
      ),
      items: _location
          .skip(1)
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Label(
                  item,
                  color: COLOR_DARK_BLUE,
                ),
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
        padding: EdgeInsets.only(left: 0, right: 10),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 50,
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
                      backgroundColor: MaterialStatePropertyAll(COLOR_ACTIVE)),
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
                  child: const Label('OK', color: COLOR_WHITE),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
