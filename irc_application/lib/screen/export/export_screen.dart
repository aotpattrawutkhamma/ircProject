import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:irc_application/config/app_constants.dart';
import 'package:irc_application/models/datasheet.dart';
import 'package:irc_application/widgets/Custom_bg.dart';
import 'package:irc_application/widgets/Custom_button.dart';
import 'package:irc_application/widgets/Label.dart';

import '../../services/sqlite.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<DatasheetModel> _datasheetModel = [];
  List<String> _location = [];
  String? _test;

  Future _getData() async {
    var sql = await databaseHelper.queryData('DATASHEET');
    if (sql.isNotEmpty) {
      setState(() {
        _datasheetModel = sql.map((e) => DatasheetModel.fromJson(e)).toList();
        _location = _datasheetModel.map((e) => e.LOCATION!).toSet().toList();
      });
    } else {
      print("Nodata");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBg(
        textTitle: Label(
          "Menu Export",
          color: COLOR_WHITE,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _dropdownButton(),
              SizedBox(
                height: 10,
              ),
              Center(
                child: CustomButton(
                  text: Label("Export"),
                ),
              ),
              _listviewCard()
            ],
          ),
        ));
  }

  Widget _listviewCard() {
    return Expanded(
        child: ListView.builder(
            itemCount: _datasheetModel
                .where((element) => element.LOCATION == _test)
                .toList()
                .length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: COLOR_WHITE,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label("User : ${_datasheetModel[index].USER}"),
                    Label("Location : ${_datasheetModel[index].LOCATION}"),
                    Label("Date :${_datasheetModel[index].DATE}"),
                    Label(
                      "Barcode :${_datasheetModel[index].BARCODE}",
                      maxLines: 2,
                    ),
                    Label("B1 :${_datasheetModel[index].B1}"),
                    Label("B2 :${_datasheetModel[index].B2}"),
                    Label("B3 :${_datasheetModel[index].B3}"),
                    Label("B4 :${_datasheetModel[index].B4}"),
                  ],
                ),
              );
            }));
  }

  Widget _dropdownButton() {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: COLOR_WHITE,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      isExpanded: true,
      hint: Center(
        child: Text(
          'Please Select Location',
          style: TextStyle(fontSize: 14),
        ),
      ),
      items: _location
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Label(item),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _test = value;
        });
        print(_test);
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
}
