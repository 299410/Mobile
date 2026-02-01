import 'package:freezed_annotation/freezed_annotation.dart';

part 'defense_day.freezed.dart';
part 'defense_day.g.dart';

@freezed
class DefenseDay with _$DefenseDay {
  factory DefenseDay({
    required String id,
    required DateTime date,
    required String roundId,
  }) = _DefenseDay;

  factory DefenseDay.fromJson(Map<String, dynamic> json) =>
      _$DefenseDayFromJson(json);
}
