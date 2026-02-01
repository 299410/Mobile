// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defense_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DefenseScheduleImpl _$$DefenseScheduleImplFromJson(
        Map<String, dynamic> json) =>
    _$DefenseScheduleImpl(
      id: json['id'] as String,
      lecturerId: json['lecturerId'] as String,
      date: DateTime.parse(json['date'] as String),
      slot: json['slot'] as String,
      role: json['role'] as String,
      details: json['details'] as String,
    );

Map<String, dynamic> _$$DefenseScheduleImplToJson(
        _$DefenseScheduleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lecturerId': instance.lecturerId,
      'date': instance.date.toIso8601String(),
      'slot': instance.slot,
      'role': instance.role,
      'details': instance.details,
    };
