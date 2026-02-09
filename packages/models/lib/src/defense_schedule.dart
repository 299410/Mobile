import 'package:freezed_annotation/freezed_annotation.dart';

part 'defense_schedule.freezed.dart';
part 'defense_schedule.g.dart';

@freezed
class DefenseSchedule with _$DefenseSchedule {
  factory DefenseSchedule({
    required int assignmentId,
    required int blockId,
    required String blockName,
    required String defenseDate,
    required String startTime,
    required String endTime,
    required int lecturerId,
    required String lecturerCode,
    required String lecturerName,
    required String lecturerEmail,
    required int roleId,
    required String roleCode,
    required String roleName,
  }) = _DefenseSchedule;

  factory DefenseSchedule.fromJson(Map<String, dynamic> json) =>
      _$DefenseScheduleFromJson(json);

  const DefenseSchedule._();

  DateTime get date => DateTime.parse(defenseDate);
}
