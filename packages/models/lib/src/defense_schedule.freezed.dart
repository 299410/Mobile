// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'defense_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DefenseSchedule _$DefenseScheduleFromJson(Map<String, dynamic> json) {
  return _DefenseSchedule.fromJson(json);
}

/// @nodoc
mixin _$DefenseSchedule {
  String get id => throw _privateConstructorUsedError;
  String get lecturerId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get slot => throw _privateConstructorUsedError; // 'Block 1', 'Block 2'
  String get role =>
      throw _privateConstructorUsedError; // 'President', 'Secretary', 'Member'
  String get details => throw _privateConstructorUsedError;

  /// Serializes this DefenseSchedule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DefenseSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DefenseScheduleCopyWith<DefenseSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefenseScheduleCopyWith<$Res> {
  factory $DefenseScheduleCopyWith(
          DefenseSchedule value, $Res Function(DefenseSchedule) then) =
      _$DefenseScheduleCopyWithImpl<$Res, DefenseSchedule>;
  @useResult
  $Res call(
      {String id,
      String lecturerId,
      DateTime date,
      String slot,
      String role,
      String details});
}

/// @nodoc
class _$DefenseScheduleCopyWithImpl<$Res, $Val extends DefenseSchedule>
    implements $DefenseScheduleCopyWith<$Res> {
  _$DefenseScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DefenseSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lecturerId = null,
    Object? date = null,
    Object? slot = null,
    Object? role = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lecturerId: null == lecturerId
          ? _value.lecturerId
          : lecturerId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DefenseScheduleImplCopyWith<$Res>
    implements $DefenseScheduleCopyWith<$Res> {
  factory _$$DefenseScheduleImplCopyWith(_$DefenseScheduleImpl value,
          $Res Function(_$DefenseScheduleImpl) then) =
      __$$DefenseScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String lecturerId,
      DateTime date,
      String slot,
      String role,
      String details});
}

/// @nodoc
class __$$DefenseScheduleImplCopyWithImpl<$Res>
    extends _$DefenseScheduleCopyWithImpl<$Res, _$DefenseScheduleImpl>
    implements _$$DefenseScheduleImplCopyWith<$Res> {
  __$$DefenseScheduleImplCopyWithImpl(
      _$DefenseScheduleImpl _value, $Res Function(_$DefenseScheduleImpl) _then)
      : super(_value, _then);

  /// Create a copy of DefenseSchedule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lecturerId = null,
    Object? date = null,
    Object? slot = null,
    Object? role = null,
    Object? details = null,
  }) {
    return _then(_$DefenseScheduleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      lecturerId: null == lecturerId
          ? _value.lecturerId
          : lecturerId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DefenseScheduleImpl implements _DefenseSchedule {
  _$DefenseScheduleImpl(
      {required this.id,
      required this.lecturerId,
      required this.date,
      required this.slot,
      required this.role,
      required this.details});

  factory _$DefenseScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefenseScheduleImplFromJson(json);

  @override
  final String id;
  @override
  final String lecturerId;
  @override
  final DateTime date;
  @override
  final String slot;
// 'Block 1', 'Block 2'
  @override
  final String role;
// 'President', 'Secretary', 'Member'
  @override
  final String details;

  @override
  String toString() {
    return 'DefenseSchedule(id: $id, lecturerId: $lecturerId, date: $date, slot: $slot, role: $role, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefenseScheduleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lecturerId, lecturerId) ||
                other.lecturerId == lecturerId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, lecturerId, date, slot, role, details);

  /// Create a copy of DefenseSchedule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DefenseScheduleImplCopyWith<_$DefenseScheduleImpl> get copyWith =>
      __$$DefenseScheduleImplCopyWithImpl<_$DefenseScheduleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DefenseScheduleImplToJson(
      this,
    );
  }
}

abstract class _DefenseSchedule implements DefenseSchedule {
  factory _DefenseSchedule(
      {required final String id,
      required final String lecturerId,
      required final DateTime date,
      required final String slot,
      required final String role,
      required final String details}) = _$DefenseScheduleImpl;

  factory _DefenseSchedule.fromJson(Map<String, dynamic> json) =
      _$DefenseScheduleImpl.fromJson;

  @override
  String get id;
  @override
  String get lecturerId;
  @override
  DateTime get date;
  @override
  String get slot; // 'Block 1', 'Block 2'
  @override
  String get role; // 'President', 'Secretary', 'Member'
  @override
  String get details;

  /// Create a copy of DefenseSchedule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DefenseScheduleImplCopyWith<_$DefenseScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
