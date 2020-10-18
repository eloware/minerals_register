import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sample.g.dart';

@JsonSerializable()
class Sample {
  String id;
  String serial;
  String mineral;
  String location;
  DateTime timeStamp;
  double value;
  String origin;
  String size;
  String annotation;
  String sideMineral;

  Sample();

  static Sample fromJson(Map<String, dynamic> json) {
    return _$SampleFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SampleToJson(this);

  static Sample fromDb(MapEntry<dynamic, dynamic> data) =>
      Sample.fromJson(Map<String, dynamic>.from(data.value))..id = data.key;

  static List<Sample> listFromDb(AsyncSnapshot<dynamic> snapshot) =>
      (snapshot.data as Event)
          .snapshot
          .value
          .entries
          .map<Sample>((e) => Sample.fromDb(e))
          .toList();
}
