class FileCsvModel {
  const FileCsvModel({
    this.ID,
    this.LOCATION,
    this.DATA,
  });
  final int? ID;
  final String? LOCATION;
  final String? DATA;

  List<Object> get props => [
        ID!,
        LOCATION!,
        DATA!,
      ];
  FileCsvModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        LOCATION = map['LOCATION'],
        DATA = map['DATA'];
}
