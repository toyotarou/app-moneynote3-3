// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_graph_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MoneyGraphResponseState {
  String get displayGraphFlag => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoneyGraphResponseStateCopyWith<MoneyGraphResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyGraphResponseStateCopyWith<$Res> {
  factory $MoneyGraphResponseStateCopyWith(MoneyGraphResponseState value,
          $Res Function(MoneyGraphResponseState) then) =
      _$MoneyGraphResponseStateCopyWithImpl<$Res, MoneyGraphResponseState>;
  @useResult
  $Res call({String displayGraphFlag});
}

/// @nodoc
class _$MoneyGraphResponseStateCopyWithImpl<$Res,
        $Val extends MoneyGraphResponseState>
    implements $MoneyGraphResponseStateCopyWith<$Res> {
  _$MoneyGraphResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayGraphFlag = null,
  }) {
    return _then(_value.copyWith(
      displayGraphFlag: null == displayGraphFlag
          ? _value.displayGraphFlag
          : displayGraphFlag // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneyGraphResponseStateImplCopyWith<$Res>
    implements $MoneyGraphResponseStateCopyWith<$Res> {
  factory _$$MoneyGraphResponseStateImplCopyWith(
          _$MoneyGraphResponseStateImpl value,
          $Res Function(_$MoneyGraphResponseStateImpl) then) =
      __$$MoneyGraphResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String displayGraphFlag});
}

/// @nodoc
class __$$MoneyGraphResponseStateImplCopyWithImpl<$Res>
    extends _$MoneyGraphResponseStateCopyWithImpl<$Res,
        _$MoneyGraphResponseStateImpl>
    implements _$$MoneyGraphResponseStateImplCopyWith<$Res> {
  __$$MoneyGraphResponseStateImplCopyWithImpl(
      _$MoneyGraphResponseStateImpl _value,
      $Res Function(_$MoneyGraphResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayGraphFlag = null,
  }) {
    return _then(_$MoneyGraphResponseStateImpl(
      displayGraphFlag: null == displayGraphFlag
          ? _value.displayGraphFlag
          : displayGraphFlag // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MoneyGraphResponseStateImpl implements _MoneyGraphResponseState {
  const _$MoneyGraphResponseStateImpl({this.displayGraphFlag = 'total'});

  @override
  @JsonKey()
  final String displayGraphFlag;

  @override
  String toString() {
    return 'MoneyGraphResponseState(displayGraphFlag: $displayGraphFlag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneyGraphResponseStateImpl &&
            (identical(other.displayGraphFlag, displayGraphFlag) ||
                other.displayGraphFlag == displayGraphFlag));
  }

  @override
  int get hashCode => Object.hash(runtimeType, displayGraphFlag);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneyGraphResponseStateImplCopyWith<_$MoneyGraphResponseStateImpl>
      get copyWith => __$$MoneyGraphResponseStateImplCopyWithImpl<
          _$MoneyGraphResponseStateImpl>(this, _$identity);
}

abstract class _MoneyGraphResponseState implements MoneyGraphResponseState {
  const factory _MoneyGraphResponseState({final String displayGraphFlag}) =
      _$MoneyGraphResponseStateImpl;

  @override
  String get displayGraphFlag;
  @override
  @JsonKey(ignore: true)
  _$$MoneyGraphResponseStateImplCopyWith<_$MoneyGraphResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
