// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_price_adjust_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BankPriceAdjustResponseState {
  List<String> get adjustDate => throw _privateConstructorUsedError;
  List<String> get adjustDeposit => throw _privateConstructorUsedError;
  List<int> get adjustPrice => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BankPriceAdjustResponseStateCopyWith<BankPriceAdjustResponseState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankPriceAdjustResponseStateCopyWith<$Res> {
  factory $BankPriceAdjustResponseStateCopyWith(
          BankPriceAdjustResponseState value,
          $Res Function(BankPriceAdjustResponseState) then) =
      _$BankPriceAdjustResponseStateCopyWithImpl<$Res,
          BankPriceAdjustResponseState>;
  @useResult
  $Res call(
      {List<String> adjustDate,
      List<String> adjustDeposit,
      List<int> adjustPrice});
}

/// @nodoc
class _$BankPriceAdjustResponseStateCopyWithImpl<$Res,
        $Val extends BankPriceAdjustResponseState>
    implements $BankPriceAdjustResponseStateCopyWith<$Res> {
  _$BankPriceAdjustResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adjustDate = null,
    Object? adjustDeposit = null,
    Object? adjustPrice = null,
  }) {
    return _then(_value.copyWith(
      adjustDate: null == adjustDate
          ? _value.adjustDate
          : adjustDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adjustDeposit: null == adjustDeposit
          ? _value.adjustDeposit
          : adjustDeposit // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adjustPrice: null == adjustPrice
          ? _value.adjustPrice
          : adjustPrice // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankPriceAdjustResponseStateImplCopyWith<$Res>
    implements $BankPriceAdjustResponseStateCopyWith<$Res> {
  factory _$$BankPriceAdjustResponseStateImplCopyWith(
          _$BankPriceAdjustResponseStateImpl value,
          $Res Function(_$BankPriceAdjustResponseStateImpl) then) =
      __$$BankPriceAdjustResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> adjustDate,
      List<String> adjustDeposit,
      List<int> adjustPrice});
}

/// @nodoc
class __$$BankPriceAdjustResponseStateImplCopyWithImpl<$Res>
    extends _$BankPriceAdjustResponseStateCopyWithImpl<$Res,
        _$BankPriceAdjustResponseStateImpl>
    implements _$$BankPriceAdjustResponseStateImplCopyWith<$Res> {
  __$$BankPriceAdjustResponseStateImplCopyWithImpl(
      _$BankPriceAdjustResponseStateImpl _value,
      $Res Function(_$BankPriceAdjustResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adjustDate = null,
    Object? adjustDeposit = null,
    Object? adjustPrice = null,
  }) {
    return _then(_$BankPriceAdjustResponseStateImpl(
      adjustDate: null == adjustDate
          ? _value._adjustDate
          : adjustDate // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adjustDeposit: null == adjustDeposit
          ? _value._adjustDeposit
          : adjustDeposit // ignore: cast_nullable_to_non_nullable
              as List<String>,
      adjustPrice: null == adjustPrice
          ? _value._adjustPrice
          : adjustPrice // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc

class _$BankPriceAdjustResponseStateImpl
    implements _BankPriceAdjustResponseState {
  const _$BankPriceAdjustResponseStateImpl(
      {final List<String> adjustDate = const [],
      final List<String> adjustDeposit = const [],
      final List<int> adjustPrice = const []})
      : _adjustDate = adjustDate,
        _adjustDeposit = adjustDeposit,
        _adjustPrice = adjustPrice;

  final List<String> _adjustDate;
  @override
  @JsonKey()
  List<String> get adjustDate {
    if (_adjustDate is EqualUnmodifiableListView) return _adjustDate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adjustDate);
  }

  final List<String> _adjustDeposit;
  @override
  @JsonKey()
  List<String> get adjustDeposit {
    if (_adjustDeposit is EqualUnmodifiableListView) return _adjustDeposit;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adjustDeposit);
  }

  final List<int> _adjustPrice;
  @override
  @JsonKey()
  List<int> get adjustPrice {
    if (_adjustPrice is EqualUnmodifiableListView) return _adjustPrice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adjustPrice);
  }

  @override
  String toString() {
    return 'BankPriceAdjustResponseState(adjustDate: $adjustDate, adjustDeposit: $adjustDeposit, adjustPrice: $adjustPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankPriceAdjustResponseStateImpl &&
            const DeepCollectionEquality()
                .equals(other._adjustDate, _adjustDate) &&
            const DeepCollectionEquality()
                .equals(other._adjustDeposit, _adjustDeposit) &&
            const DeepCollectionEquality()
                .equals(other._adjustPrice, _adjustPrice));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_adjustDate),
      const DeepCollectionEquality().hash(_adjustDeposit),
      const DeepCollectionEquality().hash(_adjustPrice));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BankPriceAdjustResponseStateImplCopyWith<
          _$BankPriceAdjustResponseStateImpl>
      get copyWith => __$$BankPriceAdjustResponseStateImplCopyWithImpl<
          _$BankPriceAdjustResponseStateImpl>(this, _$identity);
}

abstract class _BankPriceAdjustResponseState
    implements BankPriceAdjustResponseState {
  const factory _BankPriceAdjustResponseState(
      {final List<String> adjustDate,
      final List<String> adjustDeposit,
      final List<int> adjustPrice}) = _$BankPriceAdjustResponseStateImpl;

  @override
  List<String> get adjustDate;
  @override
  List<String> get adjustDeposit;
  @override
  List<int> get adjustPrice;
  @override
  @JsonKey(ignore: true)
  _$$BankPriceAdjustResponseStateImplCopyWith<
          _$BankPriceAdjustResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
