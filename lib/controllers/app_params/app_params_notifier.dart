import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app_params_response_state.dart';

final AutoDisposeStateNotifierProvider<AppParamNotifier, AppParamsResponseState> appParamProvider =
    StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>(
  (AutoDisposeStateNotifierProviderRef<AppParamNotifier, AppParamsResponseState> ref) {
    return AppParamNotifier(
      AppParamsResponseState(
        sameDaySelectedDay: DateTime.now().day,
        sameYearDayCalendarSelectDate: '${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day}',
        configUseEasyLoginFlag: false,
        configUseBankManageFlag: false,
        configUseEmoneyManageFlag: false,
      ),
    );
  },
);

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  void setCalendarSelectedDate({required DateTime date}) => state = state.copyWith(calendarSelectedDate: date);

  ///
  void setMenuNumber({required int menuNumber}) => state = state.copyWith(menuNumber: menuNumber);

  ///
  void setSelectedIncomeYear({required String year}) => state = state.copyWith(selectedIncomeYear: year);

  ///
  void setSameMonthIncomeDeleteFlag({required bool flag}) => state = state.copyWith(sameMonthIncomeDeleteFlag: flag);

  ///
  void setIncomeInputDate({required String date}) => state = state.copyWith(incomeInputDate: date);

  ///
  Future<void> setInputButtonClicked({required bool flag}) async => state = state.copyWith(inputButtonClicked: flag);

  ///
  void setSameDaySelectedDay({required int day}) => state = state.copyWith(sameDaySelectedDay: day);

  ///
  void setSelectedGraphMonth({required int month}) => state = state.copyWith(selectedGraphMonth: month);

  ///
  void setCalendarDisp({required bool flag}) => state = state.copyWith(calendarDisp: flag);

  ///
  void setSelectedYearlySpendCircleGraphSpendItem({required String item}) =>
      state = state.copyWith(selectedYearlySpendCircleGraphSpendItem: item);

  ///
  void setRepairSelectValue({required String date, required int kind}) =>
      state = state.copyWith(repairSelectDate: date, repairSelectKind: kind);

  ///
  void setRepairSelectFlag({required bool flag}) => state = state.copyWith(repairSelectFlag: flag);

  ///
  void setSelectedRepairRecordNumber({required int number}) {
    final List<int> list = <int>[...state.selectedRepairRecordNumber];
    list.add(number);
    state = state.copyWith(selectedRepairRecordNumber: list);
  }

  ///
  void clearSelectedRepairRecordNumber() => state = state.copyWith(selectedRepairRecordNumber: <int>[]);

  ///
  void setMoneyRepairInputParams({
    required List<OverlayEntry>? bigEntries,
    required void Function(VoidCallback fn)? setStateCallback,
  }) {
    state = state.copyWith(bigEntries: bigEntries, setStateCallback: setStateCallback);
  }

  ///
  void updateOverlayPosition(Offset newPos) => state = state.copyWith(overlayPosition: newPos);

  ///
  void setSelectedBankPriceYear({required String year}) => state = state.copyWith(selectedBankPriceYear: year);

  ///
  void setSameYearDayCalendarSelectDate({required String date}) =>
      state = state.copyWith(sameYearDayCalendarSelectDate: date);

  ///
  void setConfigUseEasyLoginFlag({required bool flag}) => state = state.copyWith(configUseEasyLoginFlag: flag);

  ///
  void setConfigUseBankManageFlag({required bool flag}) => state = state.copyWith(configUseBankManageFlag: flag);

  ///
  void setConfigUseEmoneyManageFlag({required bool flag}) => state = state.copyWith(configUseEmoneyManageFlag: flag);

  ///
  void setLoginPasswordIsObscure({required bool flag}) => state = state.copyWith(loginPasswordIsObscure: flag);
}
