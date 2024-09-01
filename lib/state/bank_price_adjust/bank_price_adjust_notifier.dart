import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bank_price_adjust_response_state.dart';

final AutoDisposeStateNotifierProvider<BankPriceAdjustNotifier,
        BankPriceAdjustResponseState> bankPriceAdjustProvider =
    StateNotifierProvider.autoDispose<BankPriceAdjustNotifier,
        BankPriceAdjustResponseState>((AutoDisposeStateNotifierProviderRef<
            BankPriceAdjustNotifier, BankPriceAdjustResponseState>
        ref) {
  // ignore: always_specify_types
  final List<String> adjustDate = List.generate(10, (index) => '日付');
  // ignore: always_specify_types
  final adjustDeposit = List.generate(10, (index) => '');
  // ignore: always_specify_types
  final List<int> adjustPrice = List.generate(10, (int index) => -1);

  return BankPriceAdjustNotifier(
    BankPriceAdjustResponseState(
        adjustDate: adjustDate,
        adjustDeposit: adjustDeposit,
        adjustPrice: adjustPrice),
  );
});

class BankPriceAdjustNotifier
    extends StateNotifier<BankPriceAdjustResponseState> {
  BankPriceAdjustNotifier(super.state);

  ///
  Future<void> setAdjustDate({required int pos, required String value}) async {
    final List<String> adjustDate = <String>[...state.adjustDate];
    adjustDate[pos] = value;
    state = state.copyWith(adjustDate: adjustDate);
  }

  ///
  Future<void> setAdjustDeposit(
      {required int pos, required String value}) async {
    final List<String> adjustDeposit = <String>[...state.adjustDeposit];
    adjustDeposit[pos] = value;
    state = state.copyWith(adjustDeposit: adjustDeposit);
  }

  ///
  Future<void> setAdjustPrice({required int pos, required int value}) async {
    final List<int> adjustPrice = <int>[...state.adjustPrice];
    adjustPrice[pos] = value;
    state = state.copyWith(adjustPrice: adjustPrice);
  }

  ///
  Future<void> clearInputValue() async {
    // ignore: always_specify_types
    final List<String> adjustDate = List.generate(10, (int index) => '日付');
    // ignore: always_specify_types
    final List<String> adjustDeposit = List.generate(10, (int index) => '');
    // ignore: always_specify_types
    final List<int> adjustPrice = List.generate(10, (int index) => 0);

    state = state.copyWith(
        adjustDate: adjustDate,
        adjustDeposit: adjustDeposit,
        adjustPrice: adjustPrice);
  }
}
