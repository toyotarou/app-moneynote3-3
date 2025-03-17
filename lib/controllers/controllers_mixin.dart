// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_params/app_params_notifier.dart';
import 'app_params/app_params_response_state.dart';
import 'bank_names/bank_names_notifier.dart';
import 'bank_names/bank_names_response_state.dart';
import 'bank_price_adjust/bank_price_adjust_notifier.dart';
import 'bank_price_adjust/bank_price_adjust_response_state.dart';
import 'calendars/calendars_notifier.dart';
import 'calendars/calendars_response_state.dart';
import 'data_download/data_download_notifier.dart';
import 'data_download/data_download_response_state.dart';
import 'holidays/holidays_notifier.dart';
import 'holidays/holidays_response_state.dart';
import 'money_graph/money_graph_notifier.dart';
import 'money_graph/money_graph_response_state.dart';
import 'money_repair/money_repair.dart';

// import 'spend_time_places/spend_time_places_notifier.dart';
// import 'spend_time_places/spend_time_places_response_state.dart';

mixin ControllersMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  //==========================================//
  AppParamsResponseState get appParamState => ref.watch(appParamProvider);

  AppParamNotifier get appParamNotifier => ref.read(appParamProvider.notifier);

//==========================================//

  BankNamesResponseState get bankNamesState => ref.watch(bankNamesProvider);

  BankNamesNotifier get bankNamesNotifier => ref.read(bankNamesProvider.notifier);

//==========================================//

  BankPriceAdjustResponseState get bankPriceAdjustState => ref.watch(bankPriceAdjustProvider);

  BankPriceAdjustNotifier get bankPriceAdjustNotifier => ref.read(bankPriceAdjustProvider.notifier);

//==========================================//

  CalendarsResponseState get calendarsState => ref.watch(calendarProvider);

  CalendarNotifier get calendarNotifier => ref.read(calendarProvider.notifier);

//==========================================//

  DataDownloadResponseState get dataDownloadState => ref.watch(dataDownloadProvider);

  DataDownloadNotifier get dataDownloadNotifier => ref.read(dataDownloadProvider.notifier);

//==========================================//

  HolidaysResponseState get holidayState => ref.watch(holidayProvider);

  HolidayNotifier get holidayNotifier => ref.read(holidayProvider.notifier);

//==========================================//

  MoneyGraphResponseState get moneyGraphState => ref.watch(moneyGraphProvider);

  MoneyGraphNotifier get moneyGraphNotifier => ref.read(moneyGraphProvider.notifier);

//==========================================//

  MoneyRepairControllerState get moneyRepairControllerState => ref.watch(moneyRepairControllerProvider);

  MoneyRepairController get moneyRepairControllerNotifier => ref.read(moneyRepairControllerProvider.notifier);

//==========================================//

// SpendTimePlacesResponseState get spendTimePlacesResponseState => ref.watch(spendTimePlaceProvider);
//
// AutoDisposeStateNotifierProvider get stateNotifierProvider => ref.read(spendTimePlaceProvider.notifier);

//==========================================//
}
