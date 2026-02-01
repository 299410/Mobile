import 'package:freezed_annotation/freezed_annotation.dart';

part 'defense_round.freezed.dart';
part 'defense_round.g.dart';

@freezed
class DefenseRound with _$DefenseRound {
  factory DefenseRound({
    required String id,
    required String name,
    required String status, // 'OPEN', 'CLOSED', 'PLANNING'
  }) = _DefenseRound;

  factory DefenseRound.fromJson(Map<String, dynamic> json) =>
      _$DefenseRoundFromJson(json);
}
