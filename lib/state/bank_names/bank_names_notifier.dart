import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/account_type.dart';
import 'bank_names_response_state.dart';

final bankNamesProvider = StateNotifierProvider.autoDispose<BankNamesNotifier, BankNamesResponseState>((ref) {
  return BankNamesNotifier(const BankNamesResponseState());
});

class BankNamesNotifier extends StateNotifier<BankNamesResponseState> {
  BankNamesNotifier(super.state);

  ///
  Future<void> setAccountType({required AccountType accountType}) async =>
      state = state.copyWith(accountType: accountType);
}
