// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sample _$SampleFromJson(Map<String, dynamic> json) {
  return Sample()
    ..id = json['id'] as String
    ..serial = json['serial'] as String
    ..mineral = json['mineral'] as String
    ..location = json['location'] as String
    ..timeStamp = json['timeStamp'] == null
        ? null
        : DateTime.parse(json['timeStamp'] as String)
    ..value = (json['value'] as num)?.toDouble()
    ..origin = json['origin'] as String
    ..size = json['size'] as String
    ..annotation = json['annotation'] as String
    ..sideMineral = json['sideMineral'] as String
    ..imageName = json['imageName'] as String
    ..geoLocation = json['geoLocation'] as String
    ..analytics = json['analytics'] as String
    ..sampleNumber = json['sampleNumber'] as String;
}

Map<String, dynamic> _$SampleToJson(Sample instance) => <String, dynamic>{
      'id': instance.id,
      'serial': instance.serial,
      'mineral': instance.mineral,
      'location': instance.location,
      'timeStamp': instance.timeStamp?.toIso8601String(),
      'value': instance.value,
      'origin': instance.origin,
      'size': instance.size,
      'annotation': instance.annotation,
      'sideMineral': instance.sideMineral,
      'imageName': instance.imageName,
      'geoLocation': instance.geoLocation,
      'analytics': instance.analytics,
      'sampleNumber': instance.sampleNumber,
    };
