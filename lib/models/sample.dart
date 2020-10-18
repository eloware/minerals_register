import 'package:json_annotation/json_annotation.dart';

part 'sample.g.dart';

@JsonSerializable()
class Sample {
  String id; // ID
  String serial; // Identifikation
  String mineral; // Mineral
  String location; // FundortZeile1
  DateTime timeStamp; // Datum
  double value; // Wert
  String origin; // woher
  String size; // Größe
  String annotation; // Bemerkung
  String sideMineral; // Begleitmineral

  Sample();

  static Sample fromJson(Map<String, dynamic> json) {
    return _$SampleFromJson(json);
  }

  Map<String, dynamic> toJson()=>_$SampleToJson(this);
}
