class DatasheetModel {
  const DatasheetModel({
    this.USER,
    this.LOCATION,
    this.DATE,
    this.BARCODE,
    this.B1,
    this.B2,
    this.B3,
    this.B4,
  });

  final String? USER;
  final String? LOCATION;
  final String? DATE;

  final String? BARCODE;
  final String? B1;
  final String? B2;
  final String? B3;
  final String? B4;

  List<Object> get props => [
        USER!,
        LOCATION!,
        DATE!,
        BARCODE!,
        B1!,
        B2!,
        B3!,
        B4!,
      ];

  static DatasheetModel fromJson(dynamic json) {
    return DatasheetModel(
      USER: json['USER'],
      LOCATION: json['LOCATION'],
      DATE: json['DATE'],
      BARCODE: json['BARCODE'],
      B1: json['B1'],
      B2: json['B2'],
      B3: json['B3'],
      B4: json['B4'],
    );
  }
}
