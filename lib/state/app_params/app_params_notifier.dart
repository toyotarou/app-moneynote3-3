import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'app_params_response_state.dart';

final appParamProvider = StateNotifierProvider.autoDispose<AppParamNotifier, AppParamsResponseState>((ref) {
  return AppParamNotifier(const AppParamsResponseState());
});

class AppParamNotifier extends StateNotifier<AppParamsResponseState> {
  AppParamNotifier(super.state);

  ///
  Future<void> setCalendarSelectedDate({required DateTime date}) async =>
      state = state.copyWith(calendarSelectedDate: date);

  ///
  Future<void> setMenuNumber({required int menuNumber}) async => state = state.copyWith(menuNumber: menuNumber);

  ///
  Future<void> setSelectedIncomeYear({required String year}) async => state = state.copyWith(selectedIncomeYear: year);

  ///
  Future<void> setSameMonthIncomeDeleteFlag({required bool flag}) async =>
      state = state.copyWith(sameMonthIncomeDeleteFlag: flag);

  ///
  Future<void> setIncomeInputDate({required String date}) async => state = state.copyWith(incomeInputDate: date);

  ///
  Future<void> setInputButtonClicked({required bool flag}) async => state = state.copyWith(inputButtonClicked: flag);
}
