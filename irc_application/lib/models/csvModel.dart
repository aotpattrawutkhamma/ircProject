class CsvModel {
  const CsvModel({this.LOCATION, this.DATA});

  final String? LOCATION;
  final String? DATA;

  List<Object> get props => [LOCATION!, DATA!];

  static CsvModel fromJson(dynamic json) {
    return CsvModel(
      LOCATION: json['Location'],
      DATA: json['DATA'],
    );
  }
}
