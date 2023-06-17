class FileCsvModel {
  const FileCsvModel({
    this.ID,
    this.LOCATION,
    this.B1,
    this.B2,
    this.B3,
    this.B4,
    this.DATE,
  });
  final int? ID;
  final String? LOCATION;
  final String? B1;
  final String? B2;
  final String? B3;
  final String? B4;
  final String? DATE;

  List<Object> get props => [
        ID!,
        LOCATION!,
        B1!,
        B2!,
        B3!,
        B4!,
        DATE!,
      ];
  FileCsvModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        LOCATION = map['LOCATION'],
        B1 = map['B1'],
        B2 = map['B2'],
        B3 = map['B3'],
        B4 = map['B4'],
        DATE = map['DATE'];
}
