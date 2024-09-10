import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/bank_name.dart';
import '../collections/bank_price.dart';
import '../collections/emoney_name.dart';
import '../collections/income.dart';
import '../collections/money.dart';
import '../collections/spend_item.dart';
import '../collections/spend_time_place.dart';
import '../extensions/extensions.dart';
import '../repository/bank_names_repository.dart';
import '../repository/bank_prices_repository.dart';
import '../repository/emoney_names_repository.dart';
import '../repository/incomes_repository.dart';
import '../repository/moneys_repository.dart';
import '../repository/spend_items_repository.dart';
import '../repository/spend_time_places_repository.dart';
import '../state/app_params/app_params_notifier.dart';
import '../state/calendars/calendars_notifier.dart';
import '../state/calendars/calendars_response_state.dart';
import '../state/holidays/holidays_notifier.dart';
import '../state/holidays/holidays_response_state.dart';
import '../utilities/functions.dart';
import '../utilities/utilities.dart';
import 'components/___dummy/___dummy_csv_input_alert.dart';
import 'components/___dummy/___dummy_data_input_alert.dart';
import 'components/___dummy/___dummy_download_alert.dart';
import 'components/all_total_money_graph_alert.dart';
import 'components/bank_price_adjust_alert.dart';
import 'components/daily_money_display_alert.dart';
import 'components/deposit_tab_alert.dart';
import 'components/download_data_list_alert.dart';
import 'components/income_input_alert.dart';
import 'components/money_list_alert.dart';
import 'components/money_score_list_alert.dart';
import 'components/parts/back_ground_image.dart';
import 'components/parts/custom_shape_clipper.dart';
import 'components/parts/menu_head_icon.dart';
import 'components/parts/money_dialog.dart';
import 'components/same_day_spend_price_list_alert.dart';
import 'components/spend_item_history_alert.dart';
import 'components/spend_item_input_alert.dart';
import 'components/spend_item_re_input_alert.dart';
import 'components/spend_monthly_list_alert.dart';
import 'components/spend_yearly_block_alert.dart';

// ignore: must_be_immutable
class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key, this.baseYm, required this.isar});

  String? baseYm;
  final Isar isar;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  DateTime _calendarMonthFirst = DateTime.now();
  final List<String> _youbiList = <String>[
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  List<String> _calendarDays = <String>[];

  Map<String, String> _holidayMap = <String, String>{};

  final Utility _utility = Utility();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Money>? moneyList = <Money>[];

  Map<String, Money> moneyMap = <String, Money>{};

  Map<String, int> dateCurrencySumMap = <String, int>{};

  List<BankPrice>? bankPriceList = <BankPrice>[];

  List<SpendTimePlace>? allSpendTimePlaceList = <SpendTimePlace>[];
  List<SpendTimePlace>? thisMonthSpendTimePlaceList = <SpendTimePlace>[];
  List<SpendTimePlace>? prevMonthSpendTimePlaceList = <SpendTimePlace>[];

  Map<String, List<SpendTimePlace>> spendTimePlaceCountMap =
      <String, List<SpendTimePlace>>{};
  List<SpendTimePlace> spendTypeBlankSpendTimePlaceList = <SpendTimePlace>[];

  Map<String, int> monthlySpendTimePlaceSumMap = <String, int>{};

  Map<String, Map<String, int>> bankPricePadMap = <String, Map<String, int>>{};
  Map<String, int> bankPriceTotalPadMap = <String, int>{};

  List<BankName>? bankNameList = <BankName>[];
  List<EmoneyName>? emoneyNameList = <EmoneyName>[];

  List<Deposit> depoNameList = <Deposit>[];

  List<SpendItem>? _spendItemList = <SpendItem>[];

  List<String> monthFirstDateList = <String>[];

  Map<String, int> monthlySpendMap = <String, int>{};

  List<Income>? _incomeList = <Income>[];

  ///
  void _init() {
    _makeMoneyList();
    _makeBankPriceList();

    _makeSpendTimePlaceList();

    _makeBankNameList();

    _makeSpendItemList();

    _makeIncomeList();
  }

  bool getAllTotalMoneyMap = false;

  Map<String, int> allTotalMoneyMap = <String, int>{};

  ///
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    Future(_init);

    if (widget.baseYm != null) {
      // ignore: always_specify_types
      Future(() => ref
          .read(calendarProvider.notifier)
          .setCalendarYearMonth(baseYm: widget.baseYm));
    }

    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text(calendarState.baseYearMonth),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _goPrevMonth,
              icon: Icon(Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(0.8), size: 14),
            ),
            IconButton(
              onPressed: (DateTime.now().yyyymm == calendarState.baseYearMonth)
                  ? null
                  : _goNextMonth,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: (DateTime.now().yyyymm == calendarState.baseYearMonth)
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.white.withOpacity(0.8),
                size: 14,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              final List<int> years = <int>[];

              dateCurrencySumMap.forEach((String key, int value) {
                final List<String> exKey = key.split('-');
                if (!years.contains(exKey[0].toInt())) {
                  years.add(exKey[0].toInt());
                }

                allTotalMoneyMap[key] =
                    dateCurrencySumMap[key]! + bankPriceTotalPadMap[key]!;
              });

              final Map<String, int> spendMapMonthly = <String, int>{};

              int mSpend = 0;
              monthlySpendMap.forEach((String key, int value) {
                mSpend += value;
                spendMapMonthly[key] = mSpend;
              });

              MoneyDialog(
                context: context,
                widget: AllTotalMoneyGraphAlert(
                  allTotalMoneyMap: allTotalMoneyMap,
                  years: years,
                  isar: widget.isar,
                  monthlyDateSumMap: dateCurrencySumMap,
                  bankPriceTotalPadMap: bankPriceTotalPadMap,
                  monthlySpendMap: spendMapMonthly,
                  thisMonthSpendTimePlaceList:
                      thisMonthSpendTimePlaceList ?? <SpendTimePlace>[],
                  allSpendTimePlaceList:
                      allSpendTimePlaceList ?? <SpendTimePlace>[],
                ),
              );
            },
            icon: Icon(Icons.stacked_line_chart,
                color: Colors.white.withOpacity(0.6), size: 20),
          ),
          IconButton(
            onPressed: () {
              MoneyDialog(
                context: context,
                widget: SameDaySpendPriceListAlert(
                    isar: widget.isar,
                    spendTimePlaceList:
                        allSpendTimePlaceList ?? <SpendTimePlace>[]),
              );
            },
            icon: Icon(FontAwesomeIcons.diamond,
                color: Colors.white.withOpacity(0.6), size: 20),
          ),
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: Icon(Icons.settings,
                color: Colors.white.withOpacity(0.6), size: 20),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          const BackGroundImage(),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: context.screenSize.height * 0.9,
              width: context.screenSize.width * 0.9,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: const Color(0xFFFBB6CE).withOpacity(0.6),
              child: Text('■',
                  style: TextStyle(color: Colors.white.withOpacity(0.1))),
            ),
          ),
          Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                _displayKurikoshiPrice(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: context.screenSize.height * 0.45),
                  child: _getCalendar(),
                ),
                _displayMonthSum(),
                Expanded(child: _displayMonthlySpendTimePlaceList()),
              ],
            ),
          ),
        ],
      ),
      endDrawer: _dispDrawer(),
    );
  }

  ///
  Widget _displayMonthSum() {
    int plusVal = 0;
    int minusVal = 0;

    if (thisMonthSpendTimePlaceList!.isNotEmpty) {
      for (final SpendTimePlace element in thisMonthSpendTimePlaceList!) {
        if (element.price > 0) {
          minusVal += element.price;
        } else {
          plusVal += element.price;
        }
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    MoneyDialog(
                      context: context,
                      widget: SpendMonthlyListAlert(
                        isar: widget.isar,
                        date: (widget.baseYm != null)
                            ? DateTime.parse('${widget.baseYm}-01 00:00:00')
                            : DateTime.now(),
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_month_rounded,
                          color: Colors.white.withOpacity(0.8)),
                      const Text('日別'),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    MoneyDialog(
                      context: context,
                      widget: SpendYearlyBlockAlert(
                        date: (widget.baseYm != null)
                            ? DateTime.parse('${widget.baseYm}-01 00:00:00')
                            : DateTime.now(),
                        isar: widget.isar,
                        allSpendTimePlaceList:
                            allSpendTimePlaceList ?? <SpendTimePlace>[],
                      ),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.calendar_month_rounded,
                          color: Colors.white.withOpacity(0.8)),
                      const Text('年間'),
                    ],
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                text: minusVal.toString().toCurrency(),
                style:
                    const TextStyle(color: Colors.yellowAccent, fontSize: 12),
                children: <TextSpan>[
                  const TextSpan(
                      text: ' + ', style: TextStyle(color: Colors.white)),
                  TextSpan(
                      text: plusVal.toString().toCurrency(),
                      style: const TextStyle(color: Colors.greenAccent)),
                  const TextSpan(
                      text: ' = ', style: TextStyle(color: Colors.white)),
                  TextSpan(
                    text: (plusVal + minusVal).toString().toCurrency(),
                    style: const TextStyle(color: Colors.orangeAccent),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget _displayKurikoshiPrice() {
    //=================================

    final List<String> exYm = (widget.baseYm != null)
        ? widget.baseYm!.split('-')
        : DateTime.now().yyyymm.split('-');

    final String lastMonthLastDate =
        DateTime(exYm[0].toInt(), exYm[1].toInt(), 0).yyyymmdd;

    final int kurikoshiMoney = (moneyMap[lastMonthLastDate] != null)
        ? _utility.makeCurrencySum(money: moneyMap[lastMonthLastDate])
        : 0;

    final int bankPriceTotal = (bankPriceTotalPadMap[lastMonthLastDate] != null)
        ? bankPriceTotalPadMap[lastMonthLastDate]!
        : 0;

    final int kurikoshi = (kurikoshiMoney != 0 && bankPriceTotal != 0)
        ? (kurikoshiMoney + bankPriceTotal)
        : 0;

    //=================================

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              blurRadius: 24,
              spreadRadius: 16,
              color: Colors.black.withOpacity(0.2))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            width: context.screenSize.width,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    DefaultTextStyle(
                      style: const TextStyle(fontSize: 10),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 5),
                          const Text('繰越'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(kurikoshi.toString().toCurrency()),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    MoneyDialog(
                      context: context,
                      widget: MoneyListAlert(
                        isar: widget.isar,
                        date: (widget.baseYm != null)
                            ? DateTime.parse('${widget.baseYm}-01 00:00:00')
                            : DateTime.now(),
                        moneyList: moneyList,
                        bankNameList: bankNameList,
                        emoneyNameList: emoneyNameList,
                        bankPricePadMap: bankPricePadMap,
                      ),
                    );
                  },
                  icon: Icon(FontAwesomeIcons.list,
                      color: Colors.white.withOpacity(0.6), size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispDrawer() {
    const bool isRelease = bool.fromEnvironment('dart.vm.product');

    return Drawer(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 60),
//              if (!isRelease) ...<Widget>[
//                 GestureDetector(
//                   onTap: () => MoneyDialog(
//                       context: context,
//                       widget: DummyDataInputAlert(isar: widget.isar)),
//                   child: Container(
//                     width: double.infinity,
//                     padding:
//                         const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
//                     margin: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                         border:
//                             Border.all(color: Colors.white.withOpacity(0.4))),
//                     child: const Text('dummy data input'),
//                   ),
//                 ),
                GestureDetector(
                  onTap: () => MoneyDialog(
                      context: context,
                      widget: DummyDownloadAlert(isar: widget.isar)),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.4))),
                    child: const Text('dummy csv download'),
                  ),
                ),
                GestureDetector(
                  onTap: () => MoneyDialog(
                      context: context,
                      widget: DummyCsvInputAlert(isar: widget.isar)),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.4))),
                    child: const Text('dummy csv input'),
                  ),
                ),
//              ],
              GestureDetector(
                onTap: () => MoneyDialog(
                    context: context,
                    widget: DepositTabAlert(isar: widget.isar)),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('金融機関、電子マネー名称登録'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref
                      .read(appParamProvider.notifier)
                      .setInputButtonClicked(flag: false);

                  MoneyDialog(
                    context: context,
                    widget: BankPriceAdjustAlert(
                        isar: widget.isar,
                        bankNameList: bankNameList,
                        emoneyNameList: emoneyNameList),
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('金融機関、電子マネー金額修正'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await ref
                      .read(appParamProvider.notifier)
                      .setSelectedIncomeYear(year: '');

                  if (mounted) {
                    await MoneyDialog(
                      context: context,
                      widget: IncomeInputAlert(
                        date: (widget.baseYm != null)
                            ? DateTime.parse('${widget.baseYm}-01 00:00:00')
                            : DateTime.now(),
                        isar: widget.isar,
                      ),
                    );
                  }
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('収入管理'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  MoneyDialog(
                    context: context,
                    widget: SpendItemInputAlert(
                      isar: widget.isar,
                      spendItemList: _spendItemList ?? <SpendItem>[],
                      spendTimePlaceCountMap: spendTimePlaceCountMap,
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('消費アイテム管理'),
                      ),
                    ),
                  ],
                ),
              ),
              if (spendTypeBlankSpendTimePlaceList.isNotEmpty) ...<Widget>[
                GestureDetector(
                  onTap: () async {
                    await ref
                        .read(appParamProvider.notifier)
                        .setInputButtonClicked(flag: false)
                        // ignore: always_specify_types
                        .then((value) {
                      MoneyDialog(
                        context: context,
                        widget: SpendItemReInputAlert(
                          isar: widget.isar,
                          spendItemList: _spendItemList ?? <SpendItem>[],
                          spendTypeBlankSpendTimePlaceList:
                              spendTypeBlankSpendTimePlaceList,
                        ),
                      );
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      const MenuHeadIcon(),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 3),
                          margin: const EdgeInsets.all(5),
                          child: const Text('消費アイテム再設定'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              GestureDetector(
                onTap: () => MoneyDialog(
                  context: context,
                  widget: MoneyScoreListAlert(
                    isar: widget.isar,
                    monthFirstDateList: monthFirstDateList,
                    dateCurrencySumMap: dateCurrencySumMap,
                    bankPriceTotalPadMap: bankPriceTotalPadMap,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('収支一覧'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  MoneyDialog(
                    context: context,
                    widget: DownloadDataListAlert(
                      isar: widget.isar,
                      moneyMap: moneyMap,
                      allSpendTimePlaceList:
                          allSpendTimePlaceList ?? <SpendTimePlace>[],
                      bankNameList: bankNameList ?? <BankName>[],
                      emoneyNameList: emoneyNameList ?? <EmoneyName>[],
                      bankPricePadMap: bankPricePadMap,
                      spendItem: _spendItemList ?? <SpendItem>[],
                      incomeList: _incomeList ?? <Income>[],
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('データダウンロード'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  showLicensePage(
                    context: context,
                    applicationIcon: const FlutterLogo(),
                    applicationName: 'Money Note',
                    applicationLegalese:
                        '\u{a9} ${DateTime.now().year} toyohide',
                    applicationVersion: '1.0',
                  );
                },
                child: Row(
                  children: <Widget>[
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('ライセンス表示'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _getCalendar() {
    monthlySpendMap = <String, int>{};

    final HolidaysResponseState holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    _calendarMonthFirst =
        DateTime.parse('${calendarState.baseYearMonth}-01 00:00:00');

    final DateTime monthEnd =
        DateTime.parse('${calendarState.nextYearMonth}-00 00:00:00');

    final int diff = monthEnd.difference(_calendarMonthFirst).inDays;
    final int monthDaysNum = diff + 1;

    final String youbi = _calendarMonthFirst.youbiStr;
    final int youbiNum =
        _youbiList.indexWhere((String element) => element == youbi);

    final int weekNum = ((monthDaysNum + youbiNum) <= 35) ? 5 : 6;

    // ignore: always_specify_types
    _calendarDays = List.generate(weekNum * 7, (int index) => '');

    for (int i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final DateTime gendate =
            _calendarMonthFirst.add(Duration(days: i - youbiNum));

        if (_calendarMonthFirst.month == gendate.month) {
          _calendarDays[i] = gendate.day.toString();
        }
      }
    }

    final List<Widget> list = <Widget>[];
    for (int i = 0; i < weekNum; i++) {
      list.add(_getCalendarRow(week: i));
    }

    return DefaultTextStyle(
        style: const TextStyle(fontSize: 10), child: Column(children: list));
  }

  ///
  Widget _getCalendarRow({required int week}) {
    final List<Widget> list = <Widget>[];

    for (int i = week * 7; i < ((week + 1) * 7); i++) {
      final String generateYmd = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month,
                  _calendarDays[i].toInt())
              .yyyymmdd;

      final String youbiStr = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month,
                  _calendarDays[i].toInt())
              .youbiStr;

      int dateDiff = 0;
      int dateSum = 0;
      if (generateYmd != '') {
        final DateTime genDate = DateTime.parse('$generateYmd 00:00:00');
        dateDiff = genDate.difference(DateTime.now()).inSeconds;

        if (dateCurrencySumMap[generateYmd] != null &&
            bankPriceTotalPadMap[generateYmd] != null) {
          dateSum = dateCurrencySumMap[generateYmd]! +
              bankPriceTotalPadMap[generateYmd]!;
        }
      }

      //-----------------------------------------------//
      int zenjitsuSum = 0;
      final String zenjitsu = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month,
                  _calendarDays[i].toInt() - 1)
              .yyyymmdd;

      if (zenjitsu != '') {
        if (dateCurrencySumMap[zenjitsu] != null &&
            bankPriceTotalPadMap[zenjitsu] != null) {
          zenjitsuSum =
              dateCurrencySumMap[zenjitsu]! + bankPriceTotalPadMap[zenjitsu]!;
        }
      }

      //-----------------------------------------------//

      /////////////////////////////////////////

      bool inputedFlag = false;

      if ((monthlySpendTimePlaceSumMap[generateYmd] != null &&
              (zenjitsuSum - dateSum) ==
                  monthlySpendTimePlaceSumMap[generateYmd]) ||
          (zenjitsuSum - dateSum) == 0) {
        inputedFlag = true;
      }

      /////////////////////////////////////////

      list.add(
        Expanded(
          child: GestureDetector(
            onTap: (_calendarDays[i] == '' || dateDiff > 0)
                ? null
                : () => MoneyDialog(
                      context: context,
                      widget: DailyMoneyDisplayAlert(
                        date: DateTime.parse('$generateYmd 00:00:00'),
                        isar: widget.isar,
                        moneyMap: moneyMap,
                        bankPricePadMap: bankPricePadMap,
                        bankPriceTotalPadMap: bankPriceTotalPadMap,
                        bankNameList: bankNameList ?? <BankName>[],
                        emoneyNameList: emoneyNameList ?? <EmoneyName>[],
                        spendItemList: _spendItemList ?? <SpendItem>[],
                        thisMonthSpendTimePlaceList:
                            thisMonthSpendTimePlaceList ?? <SpendTimePlace>[],
                        prevMonthSpendTimePlaceList:
                            prevMonthSpendTimePlaceList ?? <SpendTimePlace>[],
                      ),
                    ),
            child: Container(
              margin: const EdgeInsets.all(1),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (_calendarDays[i] == '')
                      ? Colors.transparent
                      : (generateYmd == DateTime.now().yyyymmdd)
                          ? Colors.orangeAccent.withOpacity(0.4)
                          : Colors.white.withOpacity(0.1),
                  width: 3,
                ),
                color: (_calendarDays[i] == '')
                    ? Colors.transparent
                    : (dateDiff > 0)
                        ? Colors.white.withOpacity(0.1)
                        : _utility.getYoubiColor(
                            date: generateYmd,
                            youbiStr: youbiStr,
                            holidayMap: _holidayMap),
              ),
              child: (_calendarDays[i] == '')
                  ? const Text('')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_calendarDays[i].padLeft(2, '0')),
                            if (dateDiff > 0 || dateSum == 0)
                              Container()
                            else
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: inputedFlag
                                          ? Colors.yellowAccent.withOpacity(0.3)
                                          : Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              minHeight: context.screenSize.height / 25),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(),
                                  if (dateDiff > 0 || dateSum == 0)
                                    Container()
                                  else
                                    Text((zenjitsuSum - dateSum)
                                        .toString()
                                        .toCurrency()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(),
                                  if (dateDiff > 0 || dateSum == 0)
                                    Container()
                                  else
                                    Text(dateSum.toString().toCurrency()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );

      if (generateYmd != '') {
        if (DateTime.parse('$generateYmd 00:00:00').isBefore(DateTime.now())) {
          monthlySpendMap[generateYmd] = zenjitsuSum - dateSum;
        }
      }
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  ///
  Future<void> _makeMoneyList() async {
    await MoneysRepository()
        .getMoneyList(isar: widget.isar)
        .then((List<Money>? value) {
      if (mounted) {
        setState(() {
          moneyList = value;

          if (value!.isNotEmpty) {
            value
              ..forEach((Money element) => dateCurrencySumMap[element.date] =
                  _utility.makeCurrencySum(money: element))
              ..forEach((Money element) => moneyMap[element.date] = element)
              ..forEach((Money element) {
                final List<String> exDate = element.date.split('-');
                if (exDate[2].toInt() == 1) {
                  if (!monthFirstDateList.contains(element.date)) {
                    monthFirstDateList.add(element.date);
                  }
                }
              });
          }
        });
      }
    });
  }

  ///
  Future<void> _makeBankPriceList() async {
    await BankPricesRepository()
        .getBankPriceList(isar: widget.isar)
        .then((List<BankPrice>? value) {
      if (mounted) {
        setState(() {
          bankPriceList = value;

          if (value != null) {
            final Map<String, dynamic> bankPriceMap =
                makeBankPriceMap(bankPriceList: value);
            bankPricePadMap = bankPriceMap['bankPriceDatePadMap']
                as Map<String, Map<String, int>>;
            bankPriceTotalPadMap =
                bankPriceMap['bankPriceTotalPadMap'] as Map<String, int>;
          }
        });
      }
    });
  }

  ///
  Future<void> _makeSpendTimePlaceList() async {
    spendTypeBlankSpendTimePlaceList = <SpendTimePlace>[];

    await SpendTimePlacesRepository()
        .getSpendTimePlaceList(isar: widget.isar)
        .then((List<SpendTimePlace>? value) {
      if (mounted) {
        setState(() {
          allSpendTimePlaceList = value;

          if (value!.isNotEmpty) {
            final String? yearmonth =
                (widget.baseYm != null) ? widget.baseYm : DateTime.now().yyyymm;

            final String prevYearMonth = DateTime(
                    yearmonth!.split('-')[0].toInt(),
                    yearmonth.split('-')[1].toInt() - 1)
                .yyyymm;

            if (_spendItemList != null) {
              final Map<String, List<SpendTimePlace>> map =
                  <String, List<SpendTimePlace>>{};
              for (final SpendItem element in _spendItemList!) {
                map[element.spendItemName] = <SpendTimePlace>[];
              }
              for (final SpendTimePlace element in value) {
                map[element.spendType]?.add(element);
              }
              spendTimePlaceCountMap = map;
            }

            final List<SpendTimePlace> list = <SpendTimePlace>[];
            final List<SpendTimePlace> list2 = <SpendTimePlace>[];

            final Map<String, List<int>> map = <String, List<int>>{};

            value
              ..forEach((SpendTimePlace element) {
                final List<String> exDate = element.date.split('-');

                if ('${exDate[0]}-${exDate[1]}' == yearmonth) {
                  map[element.date] = <int>[];
                }
              })
              ..forEach((SpendTimePlace element) {
                final List<String> exDate = element.date.split('-');

                if ('${exDate[0]}-${exDate[1]}' == yearmonth) {
                  map[element.date]?.add(element.price);

                  list.add(element);
                }

                if ('${exDate[0]}-${exDate[1]}' == prevYearMonth) {
                  list2.add(element);
                }

                if (element.spendType == '') {
                  spendTypeBlankSpendTimePlaceList.add(element);
                }
              });

            map.forEach((String key, List<int> value) {
              int sum = 0;
              for (final int element in value) {
                sum += element;
              }
              monthlySpendTimePlaceSumMap[key] = sum;
            });

            thisMonthSpendTimePlaceList = list;

            prevMonthSpendTimePlaceList = list2;
          }
        });
      }
    });
  }

  ///
  Widget _displayMonthlySpendTimePlaceList() {
    final List<Widget> list = <Widget>[];

    if (thisMonthSpendTimePlaceList!.isNotEmpty) {
      final Map<String, String> spendItemColorMap = <String, String>{};
      if (_spendItemList!.isNotEmpty) {
        for (final SpendItem element in _spendItemList!) {
          spendItemColorMap[element.spendItemName] = element.color;
        }
      }

      makeMonthlySpendItemSumMap(
              spendTimePlaceList: thisMonthSpendTimePlaceList!,
              spendItemList: _spendItemList)
          .forEach((String key, int value) {
        final String? lineColor =
            (spendItemColorMap[key] != null && spendItemColorMap[key] != '')
                ? spendItemColorMap[key]
                : '0xffffffff';

        list.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: DefaultTextStyle(
            style: TextStyle(color: Color(lineColor!.toInt()), fontSize: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(key),
                Row(
                  children: <Widget>[
                    Text(value.toString().toCurrency()),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => MoneyDialog(
                        context: context,
                        widget: SpendItemHistoryAlert(
                          date: (widget.baseYm != null)
                              ? DateTime.parse('${widget.baseYm}-01 00:00:00')
                              : DateTime.now(),
                          isar: widget.isar,
                          item: key,
                          sum: value,
                          from: 'home_screen',
                        ),
                      ),
                      child: Icon(Icons.info_outline_rounded,
                          color: Colors.greenAccent.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
      });
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
          style: const TextStyle(fontSize: 10),
          child: Column(mainAxisSize: MainAxisSize.min, children: list)),
    );
  }

  ///
  Future<void> _makeBankNameList() async {
    depoNameList = <Deposit>[];

    await BankNamesRepository()
        .getBankNameList(isar: widget.isar)
        .then((List<BankName>? value) {
      if (mounted) {
        setState(() {
          bankNameList = value;

          if (value!.isNotEmpty) {
            for (final BankName element in value) {
              depoNameList.add(Deposit('${element.depositType}-${element.id}',
                  '${element.bankName} ${element.branchName}'));
            }
          }
        });
      }
    });

    await _makeEmoneyNameList();
  }

  ///
  Future<void> _makeEmoneyNameList() async {
    await EmoneyNamesRepository()
        .getEmoneyNameList(isar: widget.isar)
        .then((List<EmoneyName>? value) {
      if (mounted) {
        setState(() {
          emoneyNameList = value;

          if (value!.isNotEmpty) {
            for (final EmoneyName element in value) {
              depoNameList.add(Deposit(
                  '${element.depositType}-${element.id}', element.emoneyName));
            }
          }
        });
      }
    });
  }

  ///
  void _goPrevMonth() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      // ignore: inference_failure_on_instance_creation, always_specify_types
      MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
              isar: widget.isar, baseYm: calendarState.prevYearMonth)),
    );
  }

  ///
  void _goNextMonth() {
    final CalendarsResponseState calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      // ignore: inference_failure_on_instance_creation, always_specify_types
      MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(
              isar: widget.isar, baseYm: calendarState.nextYearMonth)),
    );
  }

  ///
  Future<void> _makeSpendItemList() async => SpendItemsRepository()
          .getSpendItemList(isar: widget.isar)
          .then((List<SpendItem>? value) {
        if (mounted) {
          setState(() => _spendItemList = value);
        }
      });

  ///
  Future<void> _makeIncomeList() async => IncomesRepository()
          .getIncomeList(isar: widget.isar)
          .then((List<Income>? value) {
        if (mounted) {
          setState(() => _incomeList = value);
        }
      });
}
