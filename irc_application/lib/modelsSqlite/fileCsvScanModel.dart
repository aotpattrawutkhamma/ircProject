class FileCsvScanModel {
  const FileCsvScanModel({
    this.ID,
    this.LOCATION,
    this.USER,
    this.B1,
    this.B2,
    this.B3,
    this.B4,
    this.TIME,
    this.DATE,
  });
  final int? ID;
  final String? LOCATION;
  final String? USER;
  final String? B1;
  final String? B2;
  final String? B3;
  final String? B4;
  final String? TIME;
  final String? DATE;

  List<Object> get props => [
        ID!,
        LOCATION!,
        USER!,
        B1!,
        B2!,
        B3!,
        B4!,
        TIME!,
        DATE!,
      ];
  FileCsvScanModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        LOCATION = map['LOCATION'],
        USER = map['USER'],
        B1 = map['B1'],
        B2 = map['B2'],
        B3 = map['B3'],
        B4 = map['B4'],
        TIME = map['TIME'],
        DATE = map['DATE'];
}
