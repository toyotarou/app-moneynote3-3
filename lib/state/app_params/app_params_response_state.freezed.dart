// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_params_response_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppParamsResponseState {
  DateTime? get calendarSelectedDate => throw _privateConstructorUsedError;
  int get menuNumber => throw _privateConstructorUsedError;
  String get selectedIncomeYear => throw _privateConstructorUsedError;
  bool get sameMonthIncomeDeleteFlag => throw _privateConstructorUsedError;
  bool get inputButtonClicked => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppParamsResponseStateCopyWith<AppParamsResponseState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppParamsResponseStateCopyWith<$Res> {
  factory $AppParamsResponseStateCopyWith(AppParamsResponseState value,
          $Res Function(AppParamsResponseState) then) =
      _$AppParamsResponseStateCopyWithImpl<$Res, AppParamsResponseState>;
  @useResult
  $Res call(
      {DateTime? calendarSelectedDate,
      int menuNumber,
      String selectedIncomeYear,
      bool sameMonthIncomeDeleteFlag,
      bool inputButtonClicked});
}

/// @nodoc
class _$AppParamsResponseStateCopyWithImpl<$Res,
        $Val extends AppParamsResponseState>
    implements $AppParamsResponseStateCopyWith<$Res> {
  _$AppParamsResponseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calendarSelectedDate = freezed,
    Object? menuNumber = null,
    Object? selectedIncomeYear = null,
    Object? sameMonthIncomeDeleteFlag = null,
    Object? inputButtonClicked = null,
  }) {
    return _then(_value.copyWith(
      calendarSelectedDate: freezed == calendarSelectedDate
          ? _value.calendarSelectedDate
          : calendarSelectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      menuNumber: null == menuNumber
          ? _value.menuNumber
          : menuNumber // ignore: cast_nullable_to_non_nullable
              as int,
      selectedIncomeYear: null == selectedIncomeYear
          ? _value.selectedIncomeYear
          : selectedIncomeYear // ignore: cast_nullable_to_non_nullable
              as String,
      sameMonthIncomeDeleteFlag: null == sameMonthIncomeDeleteFlag
          ? _value.sameMonthIncomeDeleteFlag
          : sameMonthIncomeDeleteFlag // ignore: cast_nullable_to_non_nullable
              as bool,
      inputButtonClicked: null == inputButtonClicked
          ? _value.inputButtonClicked
          : inputButtonClicked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppParamsResponseStateImplCopyWith<$Res>
    implements $AppParamsResponseStateCopyWith<$Res> {
  factory _$$AppParamsResponseStateImplCopyWith(
          _$AppParamsResponseStateImpl value,
          $Res Function(_$AppParamsResponseStateImpl) then) =
      __$$AppParamsResponseStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? calendarSelectedDate,
      int menuNumber,
      String selectedIncomeYear,
      bool sameMonthIncomeDeleteFlag,
      bool inputButtonClicked});
}

/// @nodoc
class __$$AppParamsResponseStateImplCopyWithImpl<$Res>
    extends _$AppParamsResponseStateCopyWithImpl<$Res,
        _$AppParamsResponseStateImpl>
    implements _$$AppParamsResponseStateImplCopyWith<$Res> {
  __$$AppParamsResponseStateImplCopyWithImpl(
      _$AppParamsResponseStateImpl _value,
      $Res Function(_$AppParamsResponseStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calendarSelectedDate = freezed,
    Object? menuNumber = null,
    Object? selectedIncomeYear = null,
    Object? sameMonthIncomeDeleteFlag = null,
    Object? inputButtonClicked = null,
  }) {
    return _then(_$AppParamsResponseStateImpl(
      calendarSelectedDate: freezed == calendarSelectedDate
          ? _value.calendarSelectedDate
          : calendarSelectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      menuNumber: null == menuNumber
          ? _value.menuNumber
          : menuNumber // ignore: cast_nullable_to_non_nullable
              as int,
      selectedIncomeYear: null == selectedIncomeYear
          ? _value.selectedIncomeYear
          : selectedIncomeYear // ignore: cast_nullable_to_non_nullable
              as String,
      sameMonthIncomeDeleteFlag: null == sameMonthIncomeDeleteFlag
          ? _value.sameMonthIncomeDeleteFlag
          : sameMonthIncomeDeleteFlag // ignore: cast_nullable_to_non_nullable
              as bool,
      inputButtonClicked: null == inputButtonClicked
          ? _value.inputButtonClicked
          : inputButtonClicked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$AppParamsResponseStateImpl implements _AppParamsResponseState {
  const _$AppParamsResponseStateImpl(
      {this.calendarSelectedDate,
      this.menuNumber = 0,
      this.selectedIncomeYear = '',
      this.sameMonthIncomeDeleteFlag = false,
      this.inputButtonClicked = false});

  @override
  final DateTime? calendarSelectedDate;
  @override
  @JsonKey()
  final int menuNumber;
  @override
  @JsonKey()
  final String selectedIncomeYear;
  @override
  @JsonKey()
  final bool sameMonthIncomeDeleteFlag;
  @override
  @JsonKey()
  final bool inputButtonClicked;

  @override
  String toString() {
    return 'AppParamsResponseState(calendarSelectedDate: $calendarSelectedDate, menuNumber: $menuNumber, selectedIncomeYear: $selectedIncomeYear, sameMonthIncomeDeleteFlag: $sameMonthIncomeDeleteFlag, inputButtonClicked: $inputButtonClicked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppParamsResponseStateImpl &&
            (identical(other.calendarSelectedDate, calendarSelectedDate) ||
                other.calendarSelectedDate == calendarSelectedDate) &&
            (identical(other.menuNumber, menuNumber) ||
                other.menuNumber == menuNumber) &&
            (identical(other.selectedIncomeYear, selectedIncomeYear) ||
                other.selectedIncomeYear == selectedIncomeYear) &&
            (identical(other.sameMonthIncomeDeleteFlag,
                    sameMonthIncomeDeleteFlag) ||
                other.sameMonthIncomeDeleteFlag == sameMonthIncomeDeleteFlag) &&
            (identical(other.inputButtonClicked, inputButtonClicked) ||
                other.inputButtonClicked == inputButtonClicked));
  }

  @override
  int get hashCode => Object.hash(runtimeType, calendarSelectedDate, menuNumber,
      selectedIncomeYear, sameMonthIncomeDeleteFlag, inputButtonClicked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => __$$AppParamsResponseStateImplCopyWithImpl<
          _$AppParamsResponseStateImpl>(this, _$identity);
}

abstract class _AppParamsResponseState implements AppParamsResponseState {
  const factory _AppParamsResponseState(
      {final DateTime? calendarSelectedDate,
      final int menuNumber,
      final String selectedIncomeYear,
      final bool sameMonthIncomeDeleteFlag,
      final bool inputButtonClicked}) = _$AppParamsResponseStateImpl;

  @override
  DateTime? get calendarSelectedDate;
  @override
  int get menuNumber;
  @override
  String get selectedIncomeYear;
  @override
  bool get sameMonthIncomeDeleteFlag;
  @override
  bool get inputButtonClicked;
  @override
  @JsonKey(ignore: true)
  _$$AppParamsResponseStateImplCopyWith<_$AppParamsResponseStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
