import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app_params_response_state.dart';

final appParamProvider =
    StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>(
        (ref) {
  final day = DateTime.now().day;

  return AppParamNotifier(AppParamsResponseState(sameDaySelectedDay: day));
});

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  Future<void> setCalendarSelectedDate({required DateTime date}) async =>
      state = state.copyWith(calendarSelectedDate: date);

  ///
  Future<void> setMenuNumber({required int menuNumber}) async =>
      state = state.copyWith(menuNumber: menuNumber);

  ///
  Future<void> setSelectedIncomeYear({required String year}) async =>
      state = state.copyWith(selectedIncomeYear: year);

  ///
  Future<void> setSameMonthIncomeDeleteFlag({required bool flag}) async =>
      state = state.copyWith(sameMonthIncomeDeleteFlag: flag);

  ///
  Future<void> setIncomeInputDate({required String date}) async =>
      state = state.copyWith(incomeInputDate: date);

  ///
  Future<void> setInputButtonClicked({required bool flag}) async =>
      state = state.copyWith(inputButtonClicked: flag);

  ///
  Future<void> setSameDaySelectedDay({required int day}) async =>
      state = state.copyWith(sameDaySelectedDay: day);

  ///
  Future<void> setSelectedGraphMonth({required int month}) async =>
      state = state.copyWith(selectedGraphMonth: month);
}
