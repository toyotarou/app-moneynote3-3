import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';

import '../collections/bank_name.dart';
import '../collections/bank_price.dart';
import '../collections/emoney_name.dart';
import '../collections/money.dart';
import '../collections/spend_item.dart';
import '../collections/spend_time_place.dart';
import '../extensions/extensions.dart';
import '../state/app_params/app_params_notifier.dart';
import '../state/calendars/calendars_notifier.dart';
import '../state/holidays/holidays_notifier.dart';
import '../utilities/functions.dart';
import '../utilities/utilities.dart';
import 'components/___dummy_data_input_alert.dart';
import 'components/bank_price_adjust_alert.dart';
import 'components/daily_money_display_alert.dart';
import 'components/deposit_tab_alert.dart';
import 'components/income_input_alert.dart';
import 'components/money_graph_alert.dart';
import 'components/money_list_alert.dart';
import 'components/parts/back_ground_image.dart';
import 'components/parts/custom_shape_clipper.dart';
import 'components/parts/menu_head_icon.dart';
import 'components/parts/money_dialog.dart';
import 'components/spend_item_history_alert.dart';
import 'components/spend_item_input_alert.dart';
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
  final List<String> _youbiList = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  List<String> _calendarDays = [];

  Map<String, String> _holidayMap = {};

  final Utility _utility = Utility();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Money>? moneyList = [];

  Map<String, Money> moneyMap = {};

  Map<String, int> dateCurrencySumMap = {};

  List<BankPrice>? bankPriceList = [];

  List<SpendTimePlace>? monthlySpendTimePlaceList = [];
  List<SpendTimePlace>? spendTimePlaceList = [];
  Map<String, List<SpendTimePlace>> spendTimePlaceCountMap = {};
  List<SpendTimePlace> spendTypeBlankSpendTimePlaceList = [];

  Map<String, int> monthlySpendTimePlaceSumMap = {};

  Map<String, Map<String, int>> bankPricePadMap = {};
  Map<String, int> bankPriceTotalPadMap = {};

  List<BankName>? bankNameList = [];
  List<EmoneyName>? emoneyNameList = [];

  List<Deposit> depoNameList = [];

  List<SpendItem>? _spendItemList = [];

  List<String> monthFirstDateList = [];

  Map<String, int> monthlySpendMap = {};

  ///
  void _init() {
    _makeMoneyList();
    _makeBankPriceList();

    _makeMonthlySpendTimePlaceList();

    _makeBankNameList();

    _makeSpendItemList();
  }

  ///
  @override
  Widget build(BuildContext context) {
    Future(_init);

    if (widget.baseYm != null) {
      Future(() => ref.read(calendarProvider.notifier).setCalendarYearMonth(baseYm: widget.baseYm));
    }

    final calendarState = ref.watch(calendarProvider);

    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.3),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Row(
          children: [
            Text(calendarState.baseYearMonth),
            const SizedBox(width: 10),
            IconButton(
              onPressed: _goPrevMonth,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white.withOpacity(0.8), size: 14),
            ),
            IconButton(
              onPressed: (DateTime.now().yyyymm == calendarState.baseYearMonth) ? null : _goNextMonth,
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
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: Icon(Icons.settings, color: Colors.white.withOpacity(0.6), size: 20),
          )
        ],
      ),
      body: Stack(
        children: [
          const BackGroundImage(),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: context.screenSize.height * 0.9,
              width: context.screenSize.width * 0.9,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: const Color(0xFFFBB6CE).withOpacity(0.6),
              child: Text('■', style: TextStyle(color: Colors.white.withOpacity(0.1))),
            ),
          ),
          Container(
            width: context.screenSize.width,
            height: context.screenSize.height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
          ),
          SafeArea(
            child: Column(
              children: [
                _displayKurikoshiPrice(),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: context.screenSize.height * 0.45),
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
    var plusVal = 0;
    var minusVal = 0;

    if (monthlySpendTimePlaceList!.isNotEmpty) {
      makeMonthlySpendItemSumMap(spendTimePlaceList: monthlySpendTimePlaceList!, spendItemList: _spendItemList)
          .forEach((key, value) {
        if (value > 0) {
          plusVal += value;
        }

        if (value < 0) {
          minusVal += value;
        }
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    MoneyDialog(
                      context: context,
                      widget: SpendMonthlyListAlert(
                        isar: widget.isar,
                        date: (widget.baseYm != null) ? DateTime.parse('${widget.baseYm}-01 00:00:00') : DateTime.now(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: Colors.white.withOpacity(0.8)),
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
                        date: (widget.baseYm != null) ? DateTime.parse('${widget.baseYm}-01 00:00:00') : DateTime.now(),
                        isar: widget.isar,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month_rounded, color: Colors.white.withOpacity(0.8)),
                      const Text('年間'),
                    ],
                  ),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                text: plusVal.toString().toCurrency(),
                style: const TextStyle(color: Colors.yellowAccent, fontSize: 12),
                children: <TextSpan>[
                  const TextSpan(text: ' + ', style: TextStyle(color: Colors.white)),
                  TextSpan(text: minusVal.toString().toCurrency(), style: const TextStyle(color: Colors.greenAccent)),
                  const TextSpan(text: ' = ', style: TextStyle(color: Colors.white)),
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

    final exYm = (widget.baseYm != null) ? widget.baseYm!.split('-') : DateTime.now().yyyymm.split('-');

    final lastMonthLastDate = DateTime(exYm[0].toInt(), exYm[1].toInt(), 0).yyyymmdd;

    final kurikoshiMoney =
        (moneyMap[lastMonthLastDate] != null) ? _utility.makeCurrencySum(money: moneyMap[lastMonthLastDate]) : 0;

    final bankPriceTotal =
        (bankPriceTotalPadMap[lastMonthLastDate] != null) ? bankPriceTotalPadMap[lastMonthLastDate]! : 0;

    final kurikoshi = (kurikoshiMoney != 0 && bankPriceTotal != 0) ? (kurikoshiMoney + bankPriceTotal) : 0;

    //=================================

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 24, spreadRadius: 16, color: Colors.black.withOpacity(0.2))],
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
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    DefaultTextStyle(
                      style: const TextStyle(fontSize: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          const Text('繰越'),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.yellowAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                            child: Text(kurikoshi.toString().toCurrency()),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        final spendMapMonthly = <String, int>{};

                        var mSpend = 0;
                        monthlySpendMap.forEach((key, value) {
                          mSpend += value;
                          spendMapMonthly[key] = mSpend;
                        });

                        MoneyDialog(
                          context: context,
                          widget: MoneyGraphAlert(
                            date: (widget.baseYm != null)
                                ? DateTime.parse('${widget.baseYm}-01 00:00:00')
                                : DateTime.now(),
                            isar: widget.isar,
                            monthlyDateSumMap: dateCurrencySumMap,
                            bankPriceTotalPadMap: bankPriceTotalPadMap,
                            monthlySpendMap: spendMapMonthly,
                          ),
                        );
                      },
                      child: Icon(Icons.show_chart, color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => MoneyDialog(
                        context: context,
                        widget: MoneyListAlert(
                          isar: widget.isar,
                          date:
                              (widget.baseYm != null) ? DateTime.parse('${widget.baseYm}-01 00:00:00') : DateTime.now(),
                          moneyList: moneyList,
                          bankNameList: bankNameList,
                          emoneyNameList: emoneyNameList,
                          bankPriceList: bankPriceList,
                        ),
                      ),
                      child: Icon(Icons.list, color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(width: 10),
                  ],
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
    const isRelease = bool.fromEnvironment('dart.vm.product');

    return Drawer(
      backgroundColor: Colors.blueGrey.withOpacity(0.2),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              if (!isRelease)
                GestureDetector(
                  onTap: () => MoneyDialog(context: context, widget: DummyDataInputAlert(isar: widget.isar)),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.4))),
                    child: const Text('dummy data'),
                  ),
                ),
              GestureDetector(
                onTap: () => MoneyDialog(context: context, widget: DepositTabAlert(isar: widget.isar)),
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('金融機関、電子マネー名称登録'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => MoneyDialog(
                  context: context,
                  widget: BankPriceAdjustAlert(
                      isar: widget.isar, bankNameList: bankNameList, emoneyNameList: emoneyNameList),
                ),
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('金融機関、電子マネー金額修正'),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await ref.read(appParamProvider.notifier).setSelectedIncomeYear(year: '');

                  if (mounted) {
                    await MoneyDialog(
                      context: context,
                      widget: IncomeInputAlert(
                        date: (widget.baseYm != null) ? DateTime.parse('${widget.baseYm}-01 00:00:00') : DateTime.now(),
                        isar: widget.isar,
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
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
                      spendItemList: _spendItemList ?? [],
                      spendTimePlaceCountMap: spendTimePlaceCountMap,
                    ),
                  );
                },
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        margin: const EdgeInsets.all(5),
                        child: const Text('消費アイテム管理'),
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
                    applicationLegalese: '\u{a9} ${DateTime.now().year} toyohide',
                    applicationVersion: '1.0',
                  );
                },
                child: Row(
                  children: [
                    const MenuHeadIcon(),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
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
    final holidayState = ref.watch(holidayProvider);

    if (holidayState.holidayMap.value != null) {
      _holidayMap = holidayState.holidayMap.value!;
    }

    final calendarState = ref.watch(calendarProvider);

    _calendarMonthFirst = DateTime.parse('${calendarState.baseYearMonth}-01 00:00:00');

    final monthEnd = DateTime.parse('${calendarState.nextYearMonth}-00 00:00:00');

    final diff = monthEnd.difference(_calendarMonthFirst).inDays;
    final monthDaysNum = diff + 1;

    final youbi = _calendarMonthFirst.youbiStr;
    final youbiNum = _youbiList.indexWhere((element) => element == youbi);

    final weekNum = ((monthDaysNum + youbiNum) <= 35) ? 5 : 6;

    _calendarDays = List.generate(weekNum * 7, (index) => '');

    for (var i = 0; i < (weekNum * 7); i++) {
      if (i >= youbiNum) {
        final gendate = _calendarMonthFirst.add(Duration(days: i - youbiNum));

        if (_calendarMonthFirst.month == gendate.month) {
          _calendarDays[i] = gendate.day.toString();
        }
      }
    }

    final list = <Widget>[];
    for (var i = 0; i < weekNum; i++) {
      list.add(_getCalendarRow(week: i));
    }

    return DefaultTextStyle(style: const TextStyle(fontSize: 10), child: Column(children: list));
  }

  ///
  Widget _getCalendarRow({required int week}) {
    final list = <Widget>[];

    for (var i = week * 7; i < ((week + 1) * 7); i++) {
      final generateYmd = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).yyyymmdd;

      final youbiStr = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt()).youbiStr;

      var dateDiff = 0;
      var dateSum = 0;
      if (generateYmd != '') {
        final genDate = DateTime.parse('$generateYmd 00:00:00');
        dateDiff = genDate.difference(DateTime.now()).inSeconds;

        if (dateCurrencySumMap[generateYmd] != null && bankPriceTotalPadMap[generateYmd] != null) {
          dateSum = dateCurrencySumMap[generateYmd]! + bankPriceTotalPadMap[generateYmd]!;
        }
      }

      //-----------------------------------------------//
      var zenjitsuSum = 0;
      final zenjitsu = (_calendarDays[i] == '')
          ? ''
          : DateTime(_calendarMonthFirst.year, _calendarMonthFirst.month, _calendarDays[i].toInt() - 1).yyyymmdd;

      if (zenjitsu != '') {
        if (dateCurrencySumMap[zenjitsu] != null && bankPriceTotalPadMap[zenjitsu] != null) {
          zenjitsuSum = dateCurrencySumMap[zenjitsu]! + bankPriceTotalPadMap[zenjitsu]!;
        }
      }

      //-----------------------------------------------//

      /////////////////////////////////////////

      var inputedFlag = false;

      if ((monthlySpendTimePlaceSumMap[generateYmd] != null &&
              (zenjitsuSum - dateSum) == monthlySpendTimePlaceSumMap[generateYmd]) ||
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
                          date: DateTime.parse('$generateYmd 00:00:00'), isar: widget.isar, moneyMap: moneyMap),
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
                        : _utility.getYoubiColor(date: generateYmd, youbiStr: youbiStr, holidayMap: _holidayMap),
              ),
              child: (_calendarDays[i] == '')
                  ? const Text('')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_calendarDays[i].padLeft(2, '0')),
                            (dateDiff > 0 || dateSum == 0)
                                ? Container()
                                : Row(
                                    children: [
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
                          constraints: BoxConstraints(minHeight: context.screenSize.height / 25),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  (dateDiff > 0 || dateSum == 0)
                                      ? Container()
                                      : Text((zenjitsuSum - dateSum).toString().toCurrency()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  (dateDiff > 0 || dateSum == 0) ? Container() : Text(dateSum.toString().toCurrency()),
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
    }

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

  ///
  Future<void> _makeMoneyList() async {
    final moneyCollection = widget.isar.moneys;

    final getMoneys = await moneyCollection.where().sortByDate().findAll();

    if (mounted) {
      setState(() {
        moneyList = getMoneys;

        if (moneyList!.isNotEmpty) {
          moneyList!.forEach((element) => dateCurrencySumMap[element.date] = _utility.makeCurrencySum(money: element));
          moneyList!.forEach((element) => moneyMap[element.date] = element);
          moneyList!.forEach((element) {
            final exDate = element.date.split('-');
            if (exDate[2].toInt() == 1) {
              if (!monthFirstDateList.contains(element.date)) {
                monthFirstDateList.add(element.date);
              }
            }
          });
        }
      });
    }
  }

  ///
  Future<void> _makeBankPriceList() async {
    final bankPricesCollection = widget.isar.bankPrices;

    final getBankPrices = await bankPricesCollection.where().findAll();

    if (mounted) {
      setState(() {
        bankPriceList = getBankPrices;

        if (bankPriceList != null) {
          final bankPriceMap = makeBankPriceMap(bankPriceList: bankPriceList!);
          bankPricePadMap = bankPriceMap['bankPriceDatePadMap'];
          bankPriceTotalPadMap = bankPriceMap['bankPriceTotalPadMap'];
        }
      });
    }
  }

  ///
  Future<void> _makeMonthlySpendTimePlaceList() async {
    final spendTimePlacesCollection = widget.isar.spendTimePlaces;

    final yearmonth = (widget.baseYm != null) ? widget.baseYm : DateTime.now().yyyymm;

    final getSpendTimePlaces =
        await spendTimePlacesCollection.filter().dateStartsWith(yearmonth!).sortByDate().findAll();

    if (mounted) {
      setState(() {
        monthlySpendTimePlaceList = getSpendTimePlaces;

        final map = <String, List<int>>{};

        getSpendTimePlaces
          ..forEach((element) => map[element.date] = [])
          ..forEach((element) => map[element.date]?.add(element.price));

        map.forEach((key, value) {
          var sum = 0;
          value.forEach((element) => sum += element);

          monthlySpendTimePlaceSumMap[key] = sum;
        });
      });
    }
  }

  ///
  Widget _displayMonthlySpendTimePlaceList() {
    final list = <Widget>[];

    if (monthlySpendTimePlaceList!.isNotEmpty) {
      makeMonthlySpendItemSumMap(spendTimePlaceList: monthlySpendTimePlaceList!, spendItemList: _spendItemList)
          .forEach((key, value) {
        list.add(Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.3)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(key),
              Row(
                children: [
                  Text(value.toString().toCurrency()),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => MoneyDialog(
                      context: context,
                      widget: SpendItemHistoryAlert(
                        date: (widget.baseYm != null) ? DateTime.parse('${widget.baseYm}-01 00:00:00') : DateTime.now(),
                        isar: widget.isar,
                        item: key,
                        sum: value,
                      ),
                    ),
                    child: Icon(Icons.info_outline_rounded, color: Colors.greenAccent.withOpacity(0.6)),
                  ),
                ],
              ),
            ],
          ),
        ));
      });
    }

    return SingleChildScrollView(
      child: DefaultTextStyle(
          style: const TextStyle(fontSize: 10), child: Column(mainAxisSize: MainAxisSize.min, children: list)),
    );
  }

  ///
  Future<void> _makeBankNameList() async {
    depoNameList = [];

    final bankNamesCollection = widget.isar.bankNames;

    final getBankNames = await bankNamesCollection.where().findAll();

    if (mounted) {
      setState(() {
        bankNameList = getBankNames;

        if (bankNameList!.isNotEmpty) {
          bankNameList!.forEach(
            (element) => depoNameList.add(
              Deposit('${element.depositType}-${element.id}', '${element.bankName} ${element.branchName}'),
            ),
          );
        }
      });
    }

    await _makeEmoneyNameList();
  }

  ///
  Future<void> _makeEmoneyNameList() async {
    final emoneyNamesCollection = widget.isar.emoneyNames;

    final getEmoneyNames = await emoneyNamesCollection.where().findAll();

    if (mounted) {
      setState(() {
        emoneyNameList = getEmoneyNames;

        if (emoneyNameList!.isNotEmpty) {
          emoneyNameList!.forEach(
            (element) => depoNameList.add(Deposit('${element.depositType}-${element.id}', element.emoneyName)),
          );
        }
      });
    }
  }

  ///
  void _goPrevMonth() {
    final calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(isar: widget.isar, baseYm: calendarState.prevYearMonth)),
    );
  }

  ///
  void _goNextMonth() {
    final calendarState = ref.watch(calendarProvider);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(isar: widget.isar, baseYm: calendarState.nextYearMonth)),
    );
  }

  ///
  Future<void> _makeSpendItemList() async {
    final spendItemsCollection = widget.isar.spendItems;
    final getSpendItems = await spendItemsCollection.where().findAll();

    if (mounted) {
      setState(() => _spendItemList = getSpendItems);
    }
  }
}
