import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../collections/spend_time_place.dart';
import '../../extensions/extensions.dart';

part 'spend_time_place.freezed.dart';

part 'spend_time_place.g.dart';

@freezed
class SpendTimePlacesControllerState with _$SpendTimePlacesControllerState {
  const factory SpendTimePlacesControllerState({
    @Default(-1) int itemPos,
    //
    @Default(0) int diff,
    @Default('') String baseDiff,
    //
    @Default(<String>[]) List<String> spendItem,
    @Default(<String>[]) List<String> spendTime,
    @Default(<String>[]) List<String> spendPlace,
    @Default(<int>[]) List<int> spendPrice,
    @Default(<bool>[]) List<bool> minusCheck,

    //
    @Default(false) bool blinkingFlag,

    //
    @Default('') String spendTimePlaceItemChangeDate,
  }) = _SpendTimePlacesControllerState;
}

@Riverpod(keepAlive: true)
class SpendTimePlacesController extends _$SpendTimePlacesController {
  ///
  @override
  SpendTimePlacesControllerState build() {
    // ignore: always_specify_types
    final List<String> spendTime = List.generate(20, (index) => '時間');
    // ignore: always_specify_types
    final List<String> spendPlace = List.generate(20, (int index) => '');
    // ignore: always_specify_types
    final List<String> spendItem = List.generate(20, (int index) => '項目名');
    // ignore: always_specify_types
    final List<int> spendPrice = List.generate(20, (int index) => 0);

    // ignore: always_specify_types
    final List<bool> minusCheck = List.generate(20, (int index) => false);

    return SpendTimePlacesControllerState(
      spendTime: spendTime,
      spendPlace: spendPlace,
      spendItem: spendItem,
      spendPrice: spendPrice,
      minusCheck: minusCheck,
    );
  }

  ///
  void setBaseDiff({required String baseDiff}) => state = state.copyWith(baseDiff: baseDiff);

  ///
  void setBlinkingFlag({required bool blinkingFlag}) => state = state.copyWith(blinkingFlag: blinkingFlag);

  ///
  void setItemPos({required int pos}) => state = state.copyWith(itemPos: pos);

  ///
  void setSpendItem({required int pos, required String item}) {
    final List<String> spendItem = <String>[...state.spendItem];

    spendItem[pos] = item;

    state = state.copyWith(spendItem: spendItem);
  }

  ///
  void setTime({required int pos, required String time}) {
    final List<String> spendTime = <String>[...state.spendTime];
    spendTime[pos] = time;
    state = state.copyWith(spendTime: spendTime);
  }

  ///
  void setMinusCheck({required int pos}) {
    final List<bool> minusChecks = <bool>[...state.minusCheck];
    final bool check = minusChecks[pos];
    minusChecks[pos] = !check;
    state = state.copyWith(minusCheck: minusChecks);
  }

  ///
  void setPlace({required int pos, required String place}) {
    final List<String> spendPlace = <String>[...state.spendPlace];
    spendPlace[pos] = place;
    state = state.copyWith(spendPlace: spendPlace);
  }

  ///
  void setSpendPrice({required int pos, required int price}) {
    final List<int> spendPrice = <int>[...state.spendPrice];
    spendPrice[pos] = price;

    int sum = 0;
    for (int i = 0; i < spendPrice.length; i++) {
      if (state.minusCheck[i]) {
        sum -= spendPrice[i];
      } else {
        sum += spendPrice[i];
      }
    }

    final int baseDiff = state.baseDiff.toInt();
    final int diff = baseDiff - sum;

    state = state.copyWith(spendPrice: spendPrice, diff: diff);
  }

  ///
  Future<void> clearInputValue() async{
    // ignore: always_specify_types
    final List<String> spendTime = List.generate(20, (int index) => '時間');
    // ignore: always_specify_types
    final List<String> spendPlace = List.generate(20, (int index) => '');
    // ignore: always_specify_types
    final List<String> spendItem = List.generate(20, (int index) => '項目名');
    // ignore: always_specify_types
    final List<int> spendPrice = List.generate(20, (int index) => 0);
    // ignore: always_specify_types
    final List<bool> minusCheck = List.generate(20, (int index) => false);

    state = state.copyWith(
      spendTime: spendTime,
      spendPlace: spendPlace,
      spendItem: spendItem,
      spendPrice: spendPrice,
      minusCheck: minusCheck,
      itemPos: -1,
      baseDiff: '',
      diff: 0,
    );
  }

  ///
  void clearOneBox({required int pos}) {
    final List<String> spendItem = <String>[...state.spendItem];
    final List<String> spendTime = <String>[...state.spendTime];
    final List<int> spendPrice = <int>[...state.spendPrice];
    final List<String> spendPlace = <String>[...state.spendPlace];
    final List<bool> minusChecks = <bool>[...state.minusCheck];

    final bool minus = minusChecks[pos];
    final int price = spendPrice[pos];

    spendItem[pos] = '項目名';
    spendTime[pos] = '時間';
    spendPrice[pos] = 0;
    spendPlace[pos] = '';
    minusChecks[pos] = false;

    int diff = state.diff;

    if (minus) {
      diff -= price;
    } else {
      diff += price;
    }

    state = state.copyWith(
      spendTime: spendTime,
      spendPlace: spendPlace,
      spendItem: spendItem,
      spendPrice: spendPrice,
      minusCheck: minusChecks,
      diff: diff,
    );
  }

  ///
  void setUpdateSpendTimePlace({required List<SpendTimePlace> updateSpendTimePlace, required int baseDiff}) {
    try {
      final List<String> spendItem = <String>[...state.spendItem];
      final List<String> spendTime = <String>[...state.spendTime];
      final List<int> spendPrice = <int>[...state.spendPrice];
      final List<String> spendPlace = <String>[...state.spendPlace];
      final List<bool> minusChecks = <bool>[...state.minusCheck];

      int diff = 0;

      for (int i = 0; i < updateSpendTimePlace.length; i++) {
        spendItem[i] = updateSpendTimePlace[i].spendType;
        spendTime[i] = updateSpendTimePlace[i].time;
        spendPlace[i] = updateSpendTimePlace[i].place;

        diff += updateSpendTimePlace[i].price;

        if (updateSpendTimePlace[i].price < 0) {
          spendPrice[i] = updateSpendTimePlace[i].price * -1;
          minusChecks[i] = true;
        } else {
          spendPrice[i] = updateSpendTimePlace[i].price;
          minusChecks[i] = false;
        }
      }

      state = state.copyWith(
        spendTime: spendTime,
        spendPlace: spendPlace,
        spendItem: spendItem,
        spendPrice: spendPrice,
        minusCheck: minusChecks,
        baseDiff: baseDiff.toString(),
        diff: baseDiff - diff,
      );
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}
  }

  ///
  void setSpendTimePlaceItemChangeDate({required String date}) =>
      state = state.copyWith(spendTimePlaceItemChangeDate: date);
}
