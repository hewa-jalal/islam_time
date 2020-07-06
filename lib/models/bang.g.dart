// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bang.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bang _$BangFromJson(Map<String, dynamic> json) {
  return Bang(
    speda: json['speda'] as String,
    rojHalat: json['rojHalat'] as String,
    nevro: json['nevro'] as String,
    evar: json['evar'] as String,
    maghrab: json['maghrab'] as String,
    aesha: json['aesha'] as String,
    theThird: json['theThird'] == null
        ? null
        : DateTime.parse(json['theThird'] as String),
    lastThird: json['lastThird'] == null
        ? null
        : DateTime.parse(json['lastThird'] as String),
    dayTime: json['dayTime'] == null
        ? null
        : DateTime.parse(json['dayTime'] as String),
    maghrabDateTime: json['maghrabDateTime'] == null
        ? null
        : DateTime.parse(json['maghrabDateTime'] as String),
    spedaDateTime: json['spedaDateTime'] == null
        ? null
        : DateTime.parse(json['spedaDateTime'] as String),
    date: json['date'] as String,
    formattedHijriDate: json['formattedHijriDate'] as String,
  );
}

Map<String, dynamic> _$BangToJson(Bang instance) => <String, dynamic>{
      'speda': instance.speda,
      'rojHalat': instance.rojHalat,
      'nevro': instance.nevro,
      'evar': instance.evar,
      'maghrab': instance.maghrab,
      'aesha': instance.aesha,
      'theThird': instance.theThird?.toIso8601String(),
      'lastThird': instance.lastThird?.toIso8601String(),
      'dayTime': instance.dayTime?.toIso8601String(),
      'maghrabDateTime': instance.maghrabDateTime?.toIso8601String(),
      'spedaDateTime': instance.spedaDateTime?.toIso8601String(),
      'date': instance.date,
      'formattedHijriDate': instance.formattedHijriDate,
    };
