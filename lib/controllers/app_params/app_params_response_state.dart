import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_params_response_state.freezed.dart';

@freezed
class AppParamsResponseState with _$AppParamsResponseState {
  const factory AppParamsResponseState({
    DateTime? calendarSelectedDate,
    @Default(0) int menuNumber,
    @Default('') String selectedIncomeYear,
    @Default(false) bool sameMonthIncomeDeleteFlag,
    @Default('') String incomeInputDate,
    @Default(false) bool inputButtonClicked,
    @Default(0) int sameDaySelectedDay,
    @Default(0) int selectedGraphMonth,
    @Default(true) bool calendarDisp,
    @Default('') String selectedYearlySpendCircleGraphSpendItem,
    @Default('') String repairSelectDate,
    @Default(-1) int repairSelectKind,
    @Default(false) bool repairSelectFlag,
    @Default(<int>[]) List<int> selectedRepairRecordNumber,
    List<OverlayEntry>? bigEntries,
    void Function(VoidCallback fn)? setStateCallback,
    Offset? overlayPosition,
    @Default('') String selectedBankPriceYear,
    @Default('') String sameYearDayCalendarSelectDate,
    @Default(true) bool configUseEasyLoginFlag,
    @Default(true) bool configUseBankManageFlag,
    @Default(true) bool configUseEmoneyManageFlag,
    @Default(true) bool loginPasswordIsObscure,
    @Default(true) bool configUseSignUpFlag,
  }) = _AppParamsResponseState;
}
