import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../extensions/extensions.dart';
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
  Future<void> setMoneyModelListData({required int pos, required MoneyModel moneyModel}) async {
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

  ///
  void replaceMoneyModelListData(
      {required int index,
      required String date,
      required String kind,
      required int value,
      required bool repairSelectFlag,
      required String newValue,
      required int moneyModelListLength}) {
    final List<MoneyModel> list = <MoneyModel>[...state.moneyModelList];

    if (repairSelectFlag) {
      for (int i = index; i < moneyModelListLength; i++) {
        final MoneyModel moneyModel = MoneyModel(
          date: list[i].date,
          yen_10000: (kind == '10000') ? newValue.toInt() : list[i].yen_10000,
          yen_5000: (kind == '5000') ? newValue.toInt() : list[i].yen_5000,
          yen_2000: (kind == '2000') ? newValue.toInt() : list[i].yen_2000,
          yen_1000: (kind == '1000') ? newValue.toInt() : list[i].yen_1000,
          yen_500: (kind == '500') ? newValue.toInt() : list[i].yen_500,
          yen_100: (kind == '100') ? newValue.toInt() : list[i].yen_100,
          yen_50: (kind == '50') ? newValue.toInt() : list[i].yen_50,
          yen_10: (kind == '10') ? newValue.toInt() : list[i].yen_10,
          yen_5: (kind == '5') ? newValue.toInt() : list[i].yen_5,
          yen_1: (kind == '1') ? newValue.toInt() : list[i].yen_1,
        );

        list[i] = moneyModel;
      }
    } else {
      final MoneyModel moneyModel = MoneyModel(
        date: list[index].date,
        yen_10000: (kind == '10000') ? newValue.toInt() : list[index].yen_10000,
        yen_5000: (kind == '5000') ? newValue.toInt() : list[index].yen_5000,
        yen_2000: (kind == '2000') ? newValue.toInt() : list[index].yen_2000,
        yen_1000: (kind == '1000') ? newValue.toInt() : list[index].yen_1000,
        yen_500: (kind == '500') ? newValue.toInt() : list[index].yen_500,
        yen_100: (kind == '100') ? newValue.toInt() : list[index].yen_100,
        yen_50: (kind == '50') ? newValue.toInt() : list[index].yen_50,
        yen_10: (kind == '10') ? newValue.toInt() : list[index].yen_10,
        yen_5: (kind == '5') ? newValue.toInt() : list[index].yen_5,
        yen_1: (kind == '1') ? newValue.toInt() : list[index].yen_1,
      );

      list[index] = moneyModel;
    }

    state = state.copyWith(moneyModelList: list);
  }
}
