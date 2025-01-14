import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/money_model.dart';

part 'money_repair.freezed.dart';

part 'money_repair.g.dart';

@freezed
class MoneyRepairControllerState with _$MoneyRepairControllerState {
  const factory MoneyRepairControllerState({
    @Default(<MoneyModel>[]) List<MoneyModel> moneyModelList,
  }) = _MoneyRepairControllerState;
}

@Riverpod(keepAlive: true)
class MoneyRepairController extends _$MoneyRepairController {
  ///
  @override
  MoneyRepairControllerState build() {
    // ignore: always_specify_types
    final List<MoneyModel> list = List.generate(
      1000,
      (int index) => MoneyModel(
        date: '',
        yen_10000: 0,
        yen_5000: 0,
        yen_2000: 0,
        yen_1000: 0,
        yen_500: 0,
        yen_100: 0,
        yen_50: 0,
        yen_10: 0,
        yen_5: 0,
        yen_1: 0,
      ),
    );

    return MoneyRepairControllerState(moneyModelList: list);
  }

  ///
  Future<void> replaceMoneyModelListData({required int pos, required MoneyModel moneyModel}) async {
    final List<MoneyModel> list = <MoneyModel>[...state.moneyModelList];
    list[pos] = moneyModel;
    state = state.copyWith(moneyModelList: list);
  }

  ///
  Future<void> clearMoneyModelListData() async {
    // ignore: always_specify_types
    final List<MoneyModel> list = List.generate(
      1000,
      (int index) => MoneyModel(
        date: '',
        yen_10000: 0,
        yen_5000: 0,
        yen_2000: 0,
        yen_1000: 0,
        yen_500: 0,
        yen_100: 0,
        yen_50: 0,
        yen_10: 0,
        yen_5: 0,
        yen_1: 0,
      ),
    );

    state = state.copyWith(moneyModelList: list);
  }
}
