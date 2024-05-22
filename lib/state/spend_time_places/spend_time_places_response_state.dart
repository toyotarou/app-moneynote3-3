import 'package:freezed_annotation/freezed_annotation.dart';

part 'spend_time_places_response_state.freezed.dart';

@freezed
class SpendTimePlacesResponseState with _$SpendTimePlacesResponseState {
  const factory SpendTimePlacesResponseState({
    @Default(0) int itemPos,
    //
    @Default(0) int diff,
    @Default('') String baseDiff,
    //
    @Default([]) List<String> spendItem,
    @Default([]) List<String> spendTime,
    @Default([]) List<String> spendPlace,
    @Default([]) List<int> spendPrice,
    @Default([]) List<bool> minusCheck,

    //
    @Default(false) bool blinkingFlag,

    //
    @Default('') String spendTimePlaceItemChangeDate,
  }) = _SpendTimePlacesResponseState;
}
