// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'defense_round.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DefenseRound _$DefenseRoundFromJson(Map<String, dynamic> json) {
  return _DefenseRound.fromJson(json);
}

/// @nodoc
mixin _$DefenseRound {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this DefenseRound to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DefenseRound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DefenseRoundCopyWith<DefenseRound> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefenseRoundCopyWith<$Res> {
  factory $DefenseRoundCopyWith(
          DefenseRound value, $Res Function(DefenseRound) then) =
      _$DefenseRoundCopyWithImpl<$Res, DefenseRound>;
  @useResult
  $Res call({String id, String name, String status});
}

/// @nodoc
class _$DefenseRoundCopyWithImpl<$Res, $Val extends DefenseRound>
    implements $DefenseRoundCopyWith<$Res> {
  _$DefenseRoundCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DefenseRound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DefenseRoundImplCopyWith<$Res>
    implements $DefenseRoundCopyWith<$Res> {
  factory _$$DefenseRoundImplCopyWith(
          _$DefenseRoundImpl value, $Res Function(_$DefenseRoundImpl) then) =
      __$$DefenseRoundImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String status});
}

/// @nodoc
class __$$DefenseRoundImplCopyWithImpl<$Res>
    extends _$DefenseRoundCopyWithImpl<$Res, _$DefenseRoundImpl>
    implements _$$DefenseRoundImplCopyWith<$Res> {
  __$$DefenseRoundImplCopyWithImpl(
      _$DefenseRoundImpl _value, $Res Function(_$DefenseRoundImpl) _then)
      : super(_value, _then);

  /// Create a copy of DefenseRound
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
  }) {
    return _then(_$DefenseRoundImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DefenseRoundImpl implements _DefenseRound {
  _$DefenseRoundImpl(
      {required this.id, required this.name, required this.status});

  factory _$DefenseRoundImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefenseRoundImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String status;

  @override
  String toString() {
    return 'DefenseRound(id: $id, name: $name, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefenseRoundImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, status);

  /// Create a copy of DefenseRound
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DefenseRoundImplCopyWith<_$DefenseRoundImpl> get copyWith =>
      __$$DefenseRoundImplCopyWithImpl<_$DefenseRoundImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DefenseRoundImplToJson(
      this,
    );
  }
}

abstract class _DefenseRound implements DefenseRound {
  factory _DefenseRound(
      {required final String id,
      required final String name,
      required final String status}) = _$DefenseRoundImpl;

  factory _DefenseRound.fromJson(Map<String, dynamic> json) =
      _$DefenseRoundImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get status;

  /// Create a copy of DefenseRound
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DefenseRoundImplCopyWith<_$DefenseRoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
