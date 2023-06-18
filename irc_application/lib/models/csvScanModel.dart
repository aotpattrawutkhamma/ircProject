class CsvScanModel {
  const CsvScanModel(
      {this.LOCATION,
      this.USER,
      this.B1,
      this.B2,
      this.B3,
      this.B4,
      this.TIME,
      this.DATE});

  final String? LOCATION;
  final String? USER;
  final String? B1;
  final String? B2;
  final String? B3;
  final String? B4;
  final String? TIME;
  final String? DATE;

  List<Object> get props =>
      [LOCATION!, USER!, B1!, B2!, B3!, B4!, TIME!, DATE!];

  static CsvScanModel fromJson(dynamic json) {
    return CsvScanModel(
      LOCATION: json['LOCATION'],
      USER: json['USER'],
      B1: json['B1'],
      B2: json['B2'],
      B3: json['B3'],
      B4: json['B4'],
      TIME: json['TIME'],
      DATE: json['DATE'],
    );
  }
}
