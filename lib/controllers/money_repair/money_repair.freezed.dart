// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'money_repair.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoneyRepairControllerState {
  List<MoneyModel> get moneyModelList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoneyRepairControllerStateCopyWith<MoneyRepairControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyRepairControllerStateCopyWith<$Res> {
  factory $MoneyRepairControllerStateCopyWith(MoneyRepairControllerState value,
          $Res Function(MoneyRepairControllerState) then) =
      _$MoneyRepairControllerStateCopyWithImpl<$Res,
          MoneyRepairControllerState>;
  @useResult
  $Res call({List<MoneyModel> moneyModelList});
}

/// @nodoc
class _$MoneyRepairControllerStateCopyWithImpl<$Res,
        $Val extends MoneyRepairControllerState>
    implements $MoneyRepairControllerStateCopyWith<$Res> {
  _$MoneyRepairControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneyModelList = null,
  }) {
    return _then(_value.copyWith(
      moneyModelList: null == moneyModelList
          ? _value.moneyModelList
          : moneyModelList // ignore: cast_nullable_to_non_nullable
              as List<MoneyModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneyRepairControllerStateImplCopyWith<$Res>
    implements $MoneyRepairControllerStateCopyWith<$Res> {
  factory _$$MoneyRepairControllerStateImplCopyWith(
          _$MoneyRepairControllerStateImpl value,
          $Res Function(_$MoneyRepairControllerStateImpl) then) =
      __$$MoneyRepairControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MoneyModel> moneyModelList});
}

/// @nodoc
class __$$MoneyRepairControllerStateImplCopyWithImpl<$Res>
    extends _$MoneyRepairControllerStateCopyWithImpl<$Res,
        _$MoneyRepairControllerStateImpl>
    implements _$$MoneyRepairControllerStateImplCopyWith<$Res> {
  __$$MoneyRepairControllerStateImplCopyWithImpl(
      _$MoneyRepairControllerStateImpl _value,
      $Res Function(_$MoneyRepairControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moneyModelList = null,
  }) {
    return _then(_$MoneyRepairControllerStateImpl(
      moneyModelList: null == moneyModelList
          ? _value._moneyModelList
          : moneyModelList // ignore: cast_nullable_to_non_nullable
              as List<MoneyModel>,
    ));
  }
}

/// @nodoc

class _$MoneyRepairControllerStateImpl implements _MoneyRepairControllerState {
  const _$MoneyRepairControllerStateImpl(
      {final List<MoneyModel> moneyModelList = const <MoneyModel>[]})
      : _moneyModelList = moneyModelList;

  final List<MoneyModel> _moneyModelList;
  @override
  @JsonKey()
  List<MoneyModel> get moneyModelList {
    if (_moneyModelList is EqualUnmodifiableListView) return _moneyModelList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moneyModelList);
  }

  @override
  String toString() {
    return 'MoneyRepairControllerState(moneyModelList: $moneyModelList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneyRepairControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._moneyModelList, _moneyModelList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_moneyModelList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneyRepairControllerStateImplCopyWith<_$MoneyRepairControllerStateImpl>
      get copyWith => __$$MoneyRepairControllerStateImplCopyWithImpl<
          _$MoneyRepairControllerStateImpl>(this, _$identity);
}

abstract class _MoneyRepairControllerState
    implements MoneyRepairControllerState {
  const factory _MoneyRepairControllerState(
          {final List<MoneyModel> moneyModelList}) =
      _$MoneyRepairControllerStateImpl;

  @override
  List<MoneyModel> get moneyModelList;
  @override
  @JsonKey(ignore: true)
  _$$MoneyRepairControllerStateImplCopyWith<_$MoneyRepairControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
