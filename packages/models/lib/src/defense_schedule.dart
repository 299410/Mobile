import 'package:freezed_annotation/freezed_annotation.dart';

part 'defense_schedule.freezed.dart';
part 'defense_schedule.g.dart';

@freezed
class DefenseSchedule with _$DefenseSchedule {
  factory DefenseSchedule({
    required String id,
    required String lecturerId,
    required DateTime date,
    required String slot, // 'Block 1', 'Block 2'
    required String role, // 'President', 'Secretary', 'Member'
    required String details, // 'Room 201'
  }) = _DefenseSchedule;

  factory DefenseSchedule.fromJson(Map<String, dynamic> json) =>
      _$DefenseScheduleFromJson(json);
}
