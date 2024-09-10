// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_names_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BankNamesResponseState {
  AccountType get accountType => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BankNamesResponseStateCopyWith<BankNamesResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankNamesResponseStateCopyWith<$Res> {
  factory $BankNamesResponseStateCopyWith(BankNamesResponseState value,
          $Res Function(BankNamesResponseState) then) =
      _$BankNamesResponseStateCopyWithImpl<$Res, BankNamesResponseState>;
  @useResult
  $Res call({AccountType accountType});
}

/// @nodoc
class _$BankNamesResponseStateCopyWithImpl<$Res,
        $Val extends BankNamesResponseState>
    implements $BankNamesResponseStateCopyWith<$Res> {
  _$BankNamesResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountType = null,
  }) {
    return _then(_value.copyWith(
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankNamesResponseStateImplCopyWith<$Res>
    implements $BankNamesResponseStateCopyWith<$Res> {
  factory _$$BankNamesResponseStateImplCopyWith(
          _$BankNamesResponseStateImpl value,
          $Res Function(_$BankNamesResponseStateImpl) then) =
      __$$BankNamesResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AccountType accountType});
}

/// @nodoc
class __$$BankNamesResponseStateImplCopyWithImpl<$Res>
    extends _$BankNamesResponseStateCopyWithImpl<$Res,
        _$BankNamesResponseStateImpl>
    implements _$$BankNamesResponseStateImplCopyWith<$Res> {
  __$$BankNamesResponseStateImplCopyWithImpl(
      _$BankNamesResponseStateImpl _value,
      $Res Function(_$BankNamesResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountType = null,
  }) {
    return _then(_$BankNamesResponseStateImpl(
      accountType: null == accountType
          ? _value.accountType
          : accountType // ignore: cast_nullable_to_non_nullable
              as AccountType,
    ));
  }
}

/// @nodoc

class _$BankNamesResponseStateImpl implements _BankNamesResponseState {
  const _$BankNamesResponseStateImpl({this.accountType = AccountType.blank});

  @override
  @JsonKey()
  final AccountType accountType;

  @override
  String toString() {
    return 'BankNamesResponseState(accountType: $accountType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankNamesResponseStateImpl &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, accountType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BankNamesResponseStateImplCopyWith<_$BankNamesResponseStateImpl>
      get copyWith => __$$BankNamesResponseStateImplCopyWithImpl<
          _$BankNamesResponseStateImpl>(this, _$identity);
}

abstract class _BankNamesResponseState implements BankNamesResponseState {
  const factory _BankNamesResponseState({final AccountType accountType}) =
      _$BankNamesResponseStateImpl;

  @override
  AccountType get accountType;
  @override
  @JsonKey(ignore: true)
  _$$BankNamesResponseStateImplCopyWith<_$BankNamesResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
