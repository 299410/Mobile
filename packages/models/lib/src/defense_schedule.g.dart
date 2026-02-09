// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defense_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DefenseScheduleImpl _$$DefenseScheduleImplFromJson(
        Map<String, dynamic> json) =>
    _$DefenseScheduleImpl(
      assignmentId: (json['assignmentId'] as num).toInt(),
      blockId: (json['blockId'] as num).toInt(),
      blockName: json['blockName'] as String,
      defenseDate: json['defenseDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      lecturerId: (json['lecturerId'] as num).toInt(),
      lecturerCode: json['lecturerCode'] as String,
      lecturerName: json['lecturerName'] as String,
      lecturerEmail: json['lecturerEmail'] as String,
      roleId: (json['roleId'] as num).toInt(),
      roleCode: json['roleCode'] as String,
      roleName: json['roleName'] as String,
    );

Map<String, dynamic> _$$DefenseScheduleImplToJson(
        _$DefenseScheduleImpl instance) =>
    <String, dynamic>{
      'assignmentId': instance.assignmentId,
      'blockId': instance.blockId,
      'blockName': instance.blockName,
      'defenseDate': instance.defenseDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'lecturerId': instance.lecturerId,
      'lecturerCode': instance.lecturerCode,
      'lecturerName': instance.lecturerName,
      'lecturerEmail': instance.lecturerEmail,
      'roleId': instance.roleId,
      'roleCode': instance.roleCode,
      'roleName': instance.roleName,
    };
