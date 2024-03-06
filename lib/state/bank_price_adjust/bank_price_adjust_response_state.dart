import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_price_adjust_response_state.freezed.dart';

@freezed
class BankPriceAdjustResponseState with _$BankPriceAdjustResponseState {
  const factory BankPriceAdjustResponseState({
    @Default([]) List<String> adjustDate,
    @Default([]) List<String> adjustDeposit,
    @Default([]) List<int> adjustPrice,
  }) = _BankPriceAdjustResponseState;
}
