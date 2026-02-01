// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'defense_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DefenseDay _$DefenseDayFromJson(Map<String, dynamic> json) {
  return _DefenseDay.fromJson(json);
}

/// @nodoc
mixin _$DefenseDay {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get roundId => throw _privateConstructorUsedError;

  /// Serializes this DefenseDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DefenseDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DefenseDayCopyWith<DefenseDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefenseDayCopyWith<$Res> {
  factory $DefenseDayCopyWith(
          DefenseDay value, $Res Function(DefenseDay) then) =
      _$DefenseDayCopyWithImpl<$Res, DefenseDay>;
  @useResult
  $Res call({String id, DateTime date, String roundId});
}

/// @nodoc
class _$DefenseDayCopyWithImpl<$Res, $Val extends DefenseDay>
    implements $DefenseDayCopyWith<$Res> {
  _$DefenseDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DefenseDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? roundId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      roundId: null == roundId
          ? _value.roundId
          : roundId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DefenseDayImplCopyWith<$Res>
    implements $DefenseDayCopyWith<$Res> {
  factory _$$DefenseDayImplCopyWith(
          _$DefenseDayImpl value, $Res Function(_$DefenseDayImpl) then) =
      __$$DefenseDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, DateTime date, String roundId});
}

/// @nodoc
class __$$DefenseDayImplCopyWithImpl<$Res>
    extends _$DefenseDayCopyWithImpl<$Res, _$DefenseDayImpl>
    implements _$$DefenseDayImplCopyWith<$Res> {
  __$$DefenseDayImplCopyWithImpl(
      _$DefenseDayImpl _value, $Res Function(_$DefenseDayImpl) _then)
      : super(_value, _then);

  /// Create a copy of DefenseDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? roundId = null,
  }) {
    return _then(_$DefenseDayImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      roundId: null == roundId
          ? _value.roundId
          : roundId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DefenseDayImpl implements _DefenseDay {
  _$DefenseDayImpl(
      {required this.id, required this.date, required this.roundId});

  factory _$DefenseDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefenseDayImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String roundId;

  @override
  String toString() {
    return 'DefenseDay(id: $id, date: $date, roundId: $roundId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefenseDayImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.roundId, roundId) || other.roundId == roundId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, roundId);

  /// Create a copy of DefenseDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DefenseDayImplCopyWith<_$DefenseDayImpl> get copyWith =>
      __$$DefenseDayImplCopyWithImpl<_$DefenseDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DefenseDayImplToJson(
      this,
    );
  }
}

abstract class _DefenseDay implements DefenseDay {
  factory _DefenseDay(
      {required final String id,
      required final DateTime date,
      required final String roundId}) = _$DefenseDayImpl;

  factory _DefenseDay.fromJson(Map<String, dynamic> json) =
      _$DefenseDayImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get date;
  @override
  String get roundId;

  /// Create a copy of DefenseDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DefenseDayImplCopyWith<_$DefenseDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
