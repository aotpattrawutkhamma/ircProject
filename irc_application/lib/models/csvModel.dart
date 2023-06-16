class CsvModel {
  const CsvModel({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static CsvModel fromJson(dynamic json) {
    return CsvModel(
      RESULT: json['Location'],
      MESSAGE: json['DATA'],
    );
  }
}
