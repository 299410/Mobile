// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defense_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DefenseDayImpl _$$DefenseDayImplFromJson(Map<String, dynamic> json) =>
    _$DefenseDayImpl(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      roundId: json['roundId'] as String,
    );

Map<String, dynamic> _$$DefenseDayImplToJson(_$DefenseDayImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'roundId': instance.roundId,
    };
