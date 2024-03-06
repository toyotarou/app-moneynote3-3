import 'package:freezed_annotation/freezed_annotation.dart';

import '../../enums/account_type.dart';

part 'bank_names_response_state.freezed.dart';

@freezed
class BankNamesResponseState with _$BankNamesResponseState {
  const factory BankNamesResponseState({
    @Default(AccountType.blank) AccountType accountType,
  }) = _BankNamesResponseState;
}
