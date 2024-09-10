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
    @Default(<String>[]) List<String> spendItem,
    @Default(<String>[]) List<String> spendTime,
    @Default(<String>[]) List<String> spendPlace,
    @Default(<int>[]) List<int> spendPrice,
    @Default(<bool>[]) List<bool> minusCheck,

    //
    @Default(false) bool blinkingFlag,

    //
    @Default('') String spendTimePlaceItemChangeDate,
  }) = _SpendTimePlacesResponseState;
}
