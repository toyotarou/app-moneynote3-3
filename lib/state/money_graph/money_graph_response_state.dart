import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_graph_response_state.freezed.dart';

@freezed
class MoneyGraphResponseState with _$MoneyGraphResponseState {
  const factory MoneyGraphResponseState({
    @Default('total') String displayGraphFlag,
  }) = _MoneyGraphResponseState;
}
