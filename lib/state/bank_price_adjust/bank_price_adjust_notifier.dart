import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'bank_price_adjust_response_state.dart';

final bankPriceAdjustProvider =
    StateNotifierProvider.autoDispose<BankPriceAdjustNotifier, BankPriceAdjustResponseState>((ref) {
  final adjustDate = List.generate(10, (index) => '日付');
  final adjustDeposit = List.generate(10, (index) => '');
  final adjustPrice = List.generate(10, (index) => 0);

  return BankPriceAdjustNotifier(
    BankPriceAdjustResponseState(adjustDate: adjustDate, adjustDeposit: adjustDeposit, adjustPrice: adjustPrice),
  );
});

class BankPriceAdjustNotifier extends StateNotifier<BankPriceAdjustResponseState> {
  BankPriceAdjustNotifier(super.state);

  ///
  Future<void> setAdjustDate({required int pos, required String value}) async {
    final adjustDate = <String>[...state.adjustDate];
    adjustDate[pos] = value;
    state = state.copyWith(adjustDate: adjustDate);
  }

  ///
  Future<void> setAdjustDeposit({required int pos, required String value}) async {
    final adjustDeposit = <String>[...state.adjustDeposit];
    adjustDeposit[pos] = value;
    state = state.copyWith(adjustDeposit: adjustDeposit);
  }

  ///
  Future<void> setAdjustPrice({required int pos, required int value}) async {
    final adjustPrice = <int>[...state.adjustPrice];
    adjustPrice[pos] = value;
    state = state.copyWith(adjustPrice: adjustPrice);
  }

  ///
  Future<void> clearInputValue() async {
    final adjustDate = List.generate(10, (index) => '日付');
    final adjustDeposit = List.generate(10, (index) => '');
    final adjustPrice = List.generate(10, (index) => 0);

    state = state.copyWith(adjustDate: adjustDate, adjustDeposit: adjustDeposit, adjustPrice: adjustPrice);
  }
}
